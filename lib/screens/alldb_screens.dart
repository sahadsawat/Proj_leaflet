import 'package:flutter/material.dart';
import 'package:leaflet_application/screens/category_screen.dart';

class alldbscreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ManageData จัดการข้อมูลในระบบ"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }
}
