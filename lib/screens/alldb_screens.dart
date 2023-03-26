import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leaflet_application/screens/category_screen.dart';
import 'package:leaflet_application/screens/faculty_screen.dart';
import 'package:leaflet_application/screens/location_screen.dart';
import 'package:leaflet_application/screens/major_screen.dart';
import 'package:leaflet_application/screens/reportobj_screens.dart';
import 'package:leaflet_application/screens/user_screen.dart';
import 'package:leaflet_application/screens/userprofile_screen.dart';
import 'package:leaflet_application/screens/reportobj_db_screen.dart';
import 'package:leaflet_application/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class alldbscreens extends StatefulWidget {
  @override
  _alldbscreensState createState() => _alldbscreensState();
}

class _alldbscreensState extends State<alldbscreens> {
  // User? userModel;
  // String? useremail,
  //     password,
  //     firstname,
  //     lastname,
  //     usertel,
  //     userlineid,
  //     userfac,
  //     usermajor;
  @override
  void initState() {
    super.initState();

    //user
    // readCurrentInfo();
    // innitial();
  }

  // Future<Null> readCurrentInfo() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? userid = preferences.getString('user_id');
  //   print('user_id ==>> $userid');

  //   String url =
  //       'http://10.0.2.2/LeafletDB/getUserWhereId.php?isAdd=true&user_id=$userid';

  //   Response response = await Dio().get(url);
  //   print('response ==>> $response');

  //   var result = json.decode(response.data);
  //   print('result ==>> $result');

  //   for (var map in result) {
  //     print('map ==>> $map');
  //     setState(() {
  //       userModel = User.fromJson(map);
  //       useremail = userModel!.User_email;
  //       password = userModel!.User_password;
  //       firstname = userModel!.First_name;
  //       lastname = userModel!.Last_name;
  //       usertel = userModel!.User_tel;
  //       userlineid = userModel!.User_lineid;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Manage Data จัดการข้อมูลในระบบ"),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Category(หมวดหมู่)",
                      style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return category_screen();
                    }));
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label:
                      Text("Location(พื้นที่)", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return location_screen();
                    }));
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Faculty(คณะ)", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return faculty_screen();
                    }));
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Major(สาขา)", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return major_screen();
                    }));
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("User(ผู้ใช้)", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return user_screen();
                    }));
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("ReportOBJ(แจ้งหาสิ่งของ)",
                      style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return reportobj_db_screen();
                    }));
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label:
                      Text("แก้ไขข้อมูลผู้ใช้", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return userprofile_screen();
                    }));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
