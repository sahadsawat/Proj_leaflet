import 'package:flutter/material.dart';
import 'package:leaflet_application/screens/category_screen.dart';
import 'package:leaflet_application/screens/faculty_screen.dart';
import 'package:leaflet_application/screens/location_screen.dart';
import 'package:leaflet_application/screens/major_screen.dart';
import 'package:leaflet_application/screens/reportobj_screens.dart';
import 'package:leaflet_application/screens/user_screen.dart';
import 'package:leaflet_application/screens/userprofile_screen.dart';
import 'package:leaflet_application/screens/reportobj_db_screen.dart';

class alldbscreens extends StatelessWidget {
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
            ],
          ),
        ),
      ),
    );
  }
}
