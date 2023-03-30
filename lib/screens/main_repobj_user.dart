import 'package:flutter/material.dart';
import 'package:leaflet_application/screens/login_screen.dart';
import 'package:leaflet_application/widget/show_list_repobj_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leaflet_application/main.dart';
import 'package:leaflet_application/screens/userprofile_screen.dart';
import 'package:leaflet_application/screens/reportobj_screen.dart';
import 'package:leaflet_application/DashBoard.dart';

class MainReportobjUser extends StatefulWidget {
  @override
  _MainReportobjUserState createState() => _MainReportobjUserState();
}

class _MainReportobjUserState extends State<MainReportobjUser> {
  int itemIndex = 0;
  late SharedPreferences logindata;
  String? useremail;
  String? userfirstname;
  String? userid;

  Widget? currentWidget;
  @override
  void initState() {
    super.initState();
    currentWidget = ShowListRepobjUser();
    innitial();
  }

  void innitial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userid = logindata.getString('user_id');
      useremail = logindata.getString('user_email');
      userfirstname = logindata.getString('first_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        title: Text('My Report lose Item'),
        // title: Text(userfirstname == null
        //     ? 'Main User'
        //     : 'welcome $userfirstname login'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => reportobj_screen()),
              );
            },
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                showuserprofile(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                menuSignOut(),
              ],
            ),
          ],
        ),
      );
  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        "$useremail",
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        "$userfirstname",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  ListTile showuserprofile() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => userprofile_screen(),
        );
        Navigator.push(context, route);
      },
      leading: Icon(Icons.person),
      title: Text('แสดงข้อมูลของผู้ใช้'),
      subtitle: Text(''),
    );
  }

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.red.shade700),
      child: ListTile(
        onTap: () async {
          SharedPreferences prefernces = await SharedPreferences.getInstance();
          prefernces.clear();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (route) => false);
        },
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'ออกจากระบบ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
