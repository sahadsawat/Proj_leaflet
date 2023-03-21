import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:leaflet_application/DashBoard.dart';
import 'package:leaflet_application/controller/fac_service.dart';
import 'package:leaflet_application/main.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:leaflet_application/models/major.dart';
import 'package:leaflet_application/models/major2.dart';
import 'package:leaflet_application/models/major3.dart';
import 'package:leaflet_application/controller/ma_service.dart';
import 'package:leaflet_application/controller/user_service.dart';
import 'package:leaflet_application/models/user.dart';

class userprofile_screen extends StatefulWidget {
  @override
  _userprofile_screenState createState() => _userprofile_screenState();
}

class _userprofile_screenState extends State<userprofile_screen> {
  TextEditingController useremail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController usertel = TextEditingController();
  TextEditingController userlineid = TextEditingController();
  TextEditingController userfac = TextEditingController();
  TextEditingController usermajor = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //drop down
  String? _selectedfacName;
  String? _selectedmajorName;
  late List<major2> _facnameSelected;
  late List<major3> _majornameSelected3;
  late List item;
  late List<user> _user;
  @override
  void initState() {
    super.initState();
    _facnameSelected = [];
    _majornameSelected3 = [];
    _getmajor2();
    //user
    useremail = TextEditingController();
    _user = [];
    _getuser();
  }

  Future register() async {
    var url = "http://10.0.2.2/LeafletDB/userprofile_action.php";
    var response = await http.post(Uri.parse(url), body: {
      "user_email": useremail.text,
      "user_password": password.text,
      "first_name": firstname.text,
      "last_name": lastname.text,
      "user_tel": usertel.text,
      "user_lineid": userlineid.text,
      "major_id": _selectedmajorName,
    });
    if (response.body.isNotEmpty) {
      json.decode(response.body);
    }
    var data = json.decode(response.body);
    if (data == "Error") {
      Fluttertoast.showToast(
          msg: "User allready Please use another E-mail",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Registration Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoard(),
        ),
      );
    }
  }

  _getuser() {
    user_service.getuser().then((user) {
      setState(() {
        _user = user;
      });
      // _clearValues();
      // _showProgress(widget.title); // Reset the title...
      print("Length ${user.length}");
      _showValues;
    });
  }

  _showValues(user user) {
    useremail.text = user.User_email;
  }

  _getmajor(fac_id) {
    // _showProgress('Loading major...');
    _selectedmajorName = null;
    if (fac_id != '' || fac_id != null) {
      //! query data where ด้วย fac_id

      major_service.getmajor3(fac_id).then((major3) {
        // major.forEach((var data) => {
        //       if (data.Fac_id == fac_id) {print(data)}
        //     });
        setState(() {
          _majornameSelected3 = major3;
        });

        // _clearValues();
        // _showProgress(widget.title); // Reset the title...
        // print("Length ${major.length}");
      });
    } else {
      setState(() {
        _majornameSelected3 = [];
      });
    }
  }

  _getmajor2() {
    // _showProgress('Loading major...');
    major_service.getmajor2().then((major2) {
      setState(() {
        _facnameSelected = major2;
      });
      // _clearValues();
      // _showProgress(widget.title); // Reset the title...
      // print("Length ${major2.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaflet Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: useremail,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "please record Email"),
                      EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: password,
                    validator:
                        RequiredValidator(errorText: "please record Password"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: firstname,
                    validator: RequiredValidator(
                        errorText: "please record First Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: lastname,
                    validator:
                        RequiredValidator(errorText: "please record Last Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tel',
                      prefixIcon: Icon(
                        Icons.phone_iphone,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.phone,
                    controller: usertel,
                    validator: RequiredValidator(
                        errorText: "please record Telephone Number"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Line ID',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: userlineid,
                    // validator: MultiValidator([
                    //   RequiredValidator(errorText: "please record Email"),
                    //   EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                    // ]),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Faculty',
                        // prefixIcon: Icon(
                        //   Icons.,
                        // ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      value: _selectedfacName,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) =>
                          (value == null) ? 'Please Select Faculty' : null,
                      items: _facnameSelected.map((faculty) {
                        return DropdownMenuItem(
                          value: faculty.Fac_id.toString(),
                          child: Text(faculty.Fac_name),
                        );
                      }).toList(),
                      onChanged: (String? faculty) {
                        setState(() {
                          _selectedfacName = faculty!;
                          // set ค่า major ให้เป้นค่าว่างก่อน
                          _getmajor(
                              _selectedfacName); // ส่งค่า fac id ไป function get major
                        });
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Major',
                        // prefixIcon: Icon(
                        //   Icons.,
                        // ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      value: _selectedmajorName,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) =>
                          (value == null) ? 'Please Select Major' : null,
                      items: _majornameSelected3.map((major) {
                        return DropdownMenuItem(
                          value: major.Major_id.toString(),
                          child: Text(major.Major_name),
                        );
                      }).toList(),
                      onChanged: (String? major) {
                        setState(() {
                          _selectedmajorName = major!;
                        });
                      },
                    )),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Colors.pink,
                        child: Text('Register',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            register();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Colors.amber[100],
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
