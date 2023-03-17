import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:leaflet_application/DashBoard.dart';
import 'package:leaflet_application/main.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController usertel = TextEditingController();
  TextEditingController useremail = TextEditingController();
  TextEditingController userfac = TextEditingController();
  TextEditingController usermajor = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future register() async {
    var url = "http://10.0.2.2/LeafletDB/register_action.php";
    var response = await http.post(Uri.parse(url), body: {
      "user_id": userid.text,
      "user_password": password.text,
      "user_name": username.text,
      "user_tel": usertel.text,
      "user_email": useremail.text,
      // "user_password": userfac.text,
      // "major_id": usermajor.text,
    });
    if (response.body.isNotEmpty) {
      json.decode(response.body);
    }
    var data = json.decode(response.body);
    if (data == "Error") {
      Fluttertoast.showToast(
          msg: "User allready Please use another ID",
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
          backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login SignUp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                    'Register',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'ID',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: userid,
                    validator:
                        RequiredValidator(errorText: "please record user ID"),
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
                      labelText: 'Username / surname',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: username,
                    validator: RequiredValidator(
                        errorText: "please record username/surname"),
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       labelText: 'Faculty',
                //       prefixIcon: Icon(Icons.person),
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8)),
                //     ),
                //     controller: userfac,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       labelText: 'Major',
                //       prefixIcon: Icon(Icons.person),
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8)),
                //     ),
                //     controller: usermajor,
                //   ),
                // ),
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
