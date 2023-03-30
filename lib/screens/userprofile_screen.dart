import 'dart:convert';
import 'package:leaflet_application/models/faculty.dart';
import 'package:leaflet_application/screens/userprofile_edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

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
  TextEditingController textuseremail = TextEditingController();
  TextEditingController textpassword = TextEditingController();
  TextEditingController textfirstname = TextEditingController();
  TextEditingController textlastname = TextEditingController();
  TextEditingController textusertel = TextEditingController();
  TextEditingController textuserlineid = TextEditingController();
  TextEditingController textuserfac = TextEditingController();
  TextEditingController textusermajor = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //drop down
  User? userModel;
  String? useremail,
      password,
      firstname,
      lastname,
      usertel,
      userlineid,
      userfac,
      usermajor;

  User? selecteduser;

  String? _selectedmajorName;
  late List<major> _majornameSelected;
  String? _selectedfacName;
  late List<faculty> _facnameSelected;
  late List item;
  late List<User> _user;
  late SharedPreferences logindata;
  // String? userfirstname;
  // String? userid;
  // String? user_email;
  @override
  void initState() {
    super.initState();

    _facnameSelected = [];
    _majornameSelected = [];
    //user
    readCurrentInfo();
    _getmajor();
    _getfaculty();
    // innitial();
  }

  // void innitial() async {
  //   logindata = await SharedPreferences.getInstance();
  //   setState(() {
  //     userid = logindata.getString('user_id');
  //     userfirstname = logindata.getString('first_name');
  //     user_email = logindata.getString('user_email');
  //   });
  // }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString('user_id');
    print('user_id ==>> $userid');

    String url =
        'http://10.0.2.2/LeafletDB/getUserWhereId.php?isAdd=true&user_id=$userid';

    Response response = await Dio().get(url);
    print('response ==>> $response');

    var result = json.decode(response.data);
    print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = User.fromJson(map);
        textuseremail.text = userModel!.User_email;
        textpassword.text = userModel!.User_password;
        textfirstname.text = userModel!.First_name;
        textlastname.text = userModel!.Last_name;
        textusertel.text = userModel!.User_tel;
        textuserlineid.text = userModel!.User_lineid;
        _selectedmajorName = userModel!.Major_id;
        useremail = userModel!.User_email;
        password = userModel!.User_password;
        firstname = userModel!.First_name;
        lastname = userModel!.Last_name;
        usertel = userModel!.User_tel;
        userlineid = userModel!.User_lineid;
        // _selectedfacName = userModel!.Fac_id;
      });
    }
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณแน่ใจว่าจะ ปรับปรุงข้อมูลผู้ใช้?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _updateuser(userModel!);
                  editThread();
                },
                child: Text('แน่ใจ'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ไม่แน่ใจ'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future _updateuser(User user) async {
    user_service
        .updateuser2(
            user.User_id,
            textuseremail.text,
            textpassword.text,
            textfirstname.text,
            textlastname.text,
            textusertel.text,
            textuserlineid.text,
            _selectedmajorName!)
        .then((result) {
      if ('success' == result) {
        readCurrentInfo(); // Refresh the list after update
        setState(() {});
      }
    });
  }

  Future<Null> editThread() async {
    String userid = userModel!.User_id;
    String url =
        'http://10.0.2.2/LeafletDB/editUserWhereId.php?isAdd=true&user_id=$userid&user_email=$useremail&user_password=$password&first_name=$firstname&last_name=$lastname&user_tel=$usertel&user_lineid=$userlineid&major_id=$_selectedmajorName';

    Response response = await Dio().get(url);
    if (response.toString() == 'true') {
      Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => HomeApp(),
        ),
      );
    } else {}
  }

  _getmajor() {
    major_service.getmajor().then((major) {
      setState(() {
        _majornameSelected = major;
      });
      print("Length ${major.length}");
    });
  }

  _getfaculty() {
    fac_service.getfaculty().then((fac) {
      setState(() {
        _facnameSelected = fac;
      });
      print("Length ${fac.length}");
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
                    'Profile $firstname',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                    controller: textuseremail,
                    onChanged: (value) {
                      setState(() => useremail = value);
                    },
                    // initialValue: useremail,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "please record Email"),
                      EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                    controller: textpassword,
                    onChanged: (value) => password = value.trim(),
                    // initialValue: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator:
                        RequiredValidator(errorText: "please record Password"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                    controller: textfirstname,
                    onChanged: (value) => firstname = value,
                    // initialValue: firstname,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: RequiredValidator(
                        errorText: "please record First Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                    controller: textlastname,
                    onChanged: (value) => lastname = value,
                    // initialValue: lastname,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator:
                        RequiredValidator(errorText: "please record Last Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                    controller: textusertel,
                    onChanged: (value) => usertel = value,
                    // initialValue: usertel,
                    decoration: InputDecoration(
                      labelText: 'Tel',
                      prefixIcon: Icon(
                        Icons.phone_iphone,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: RequiredValidator(
                        errorText: "please record Telephone Number"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                    controller: textuserlineid,
                    onChanged: (value) => userlineid = value,
                    // initialValue: userlineid,
                    decoration: InputDecoration(
                      labelText: 'Line ID',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    // validator: MultiValidator([
                    //   RequiredValidator(errorText: "please record Email"),
                    //   EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                    // ]),
                  ),
                ),
                // Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: DropdownButtonFormField(
                //       decoration: InputDecoration(
                //         labelText: 'Faculty',
                //         // prefixIcon: Icon(
                //         //   Icons.,
                //         // ),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(8)),
                //       ),
                //       value: _selectedfacName,
                //       autovalidateMode: AutovalidateMode.always,
                //       validator: (value) =>
                //           (value == null) ? 'Please Select Faculty' : null,
                //       items: _facnameSelected.map((faculty) {
                //         return DropdownMenuItem(
                //           value: faculty.Fac_id.toString(),
                //           child: Text(faculty.Fac_name),
                //         );
                //       }).toList(),
                //       onChanged: (String? faculty) {
                //         setState(() {});
                //       },
                //     )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabled: false,
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
                      items: _majornameSelected.map((major) {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    color: Colors.orange,
                    child: Text('Edit',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => userprofile_edit_screen(),
                        ),
                      );
                    },
                  ),
                ),
                // SizedBox(),
                // Expanded(
                //   child: MaterialButton(
                //     color: Colors.red,
                //     child: Text('Cancle',
                //         style: TextStyle(
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.black)),
                //     onPressed: () {
                //       // Navigator.push(
                //       //   context,
                //       //   MaterialPageRoute(
                //       //     builder: (context) =>
                //       //     clearvalue(),
                //       //   ),
                //       // );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
