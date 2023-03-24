import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status extends StatefulWidget {
  @override
  _statusState createState() => _statusState();
}

class _statusState extends State<status> {
  late SharedPreferences logindata;
  String? userfirstname;
  String? userid;
  void initState() {
    super.initState();
    innitial();
  }

  void innitial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userid = logindata.getString('user_id');
      userfirstname = logindata.getString('first_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Preference Example'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'welcome $userfirstname to application',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
