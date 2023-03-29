import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leaflet_application/screens/alldb_screens.dart';
import 'package:leaflet_application/screens/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:leaflet_application/DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leaflet_application/models/user.dart';
import 'package:leaflet_application/screens/main_repobj.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? useremail;
  String? password;
  //share preferences
  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();

    check_if_already_login();
  }

  // @override
  // void dispose() {
  //   useremail.dispose();
  //   password.dispose();
  //   super.dispose();
  // }

  Widget showlogo() {
    return Container(
      width: 300.0,
      height: 360.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Future<Null> checkAuthen() async {
    String url =
        'http://10.0.2.2/LeafletDB/getUserWhereUser.php?isAdd=true&user_email=$useremail';
    print('url ===>> $url');
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        User user = User.fromJson(map);
        if (password == user.User_password) {
          Fluttertoast.showToast(
              msg: "Login successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          routeService(HomeScreen(), user);
        } else {
          Fluttertoast.showToast(
              msg: "E-mail and password is valid",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } catch (e) {
      print('Have e Error ===>> ${e.toString()}');
    }
  }

  Future<void> routeService(Widget myWidget, User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('login', false);
    preferences.setString("user_id", user.User_id);
    preferences.setString("user_email", user.User_email);
    preferences.setString("first_name", user.First_name);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<void> check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  bool _isHidden = true;
  bool _authenticatingStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     'Leaflet Application',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 10, 185, 100),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              showlogo(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'User E-mail',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value) => useremail = value.trim(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isHidden =
                              !_isHidden; // เมื่อกดก็เปลี่ยนค่าตรงกันข้าม
                        });
                      },
                      icon: Icon(_isHidden // เงื่อนไขการสลับ icon
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                  onChanged: (value) =>
                      password = value.trim(), // ผูกกับ TextFormField ที่จะใช้
                  obscureText:
                      _isHidden, // ก่อนซ่อนหรือแสดงข้อความในรูปแบบรหัสผ่าน
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Colors.pink,
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      onPressed: () {
                        // login();
                        checkAuthen();
                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      color: Colors.amber[100],
                      child: Text('Register',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register_screen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
