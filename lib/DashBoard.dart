import 'package:flutter/material.dart';
import 'package:leaflet_application/main.dart';
import 'package:leaflet_application/status.dart';
import 'package:leaflet_application/screens/alldb_screens.dart';
import 'package:leaflet_application/screens/userprofile_screen.dart';
import 'package:leaflet_application/screens/reportobj_screens.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const kTextStyle = TextStyle(
  fontSize: 40,
  color: Colors.grey,
  fontWeight: FontWeight.bold,
);

class _HomeScreenState extends State<HomeScreen> {
  int itemIndex = 0;
  late SharedPreferences logindata;
  String? useremail;
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
    });
  }

  List<Widget> widgetList = [
    DashBoard(),
    reportobj_screen(),
    userprofile_screen(),
    alldbscreens(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('ยินดีต้อนรับuserIDที่ $userid'),
      //   backgroundColor: Colors.black,
      // ),
      body: Center(
        child: widgetList.elementAt(itemIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            label: "Report",
            icon: Icon(Icons.graphic_eq),
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(
              Icons.person,
            ),
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            label: "manage",
            icon: Icon(
              Icons.manage_accounts,
            ),
            backgroundColor: Colors.redAccent,
          ),
        ],
        currentIndex: itemIndex,
        onTap: (index) {
          setState(() {
            itemIndex = index;
            print(index);
          });
        },
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}

//UI
class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.greenAccent,
        title: Text('Wellcome'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              SharedPreferences prefernces =
                  await SharedPreferences.getInstance();
              prefernces.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (route) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Card(
            color: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.analytics,
                    size: 50.0,
                    color: Colors.black,
                  ),
                  textColor: Colors.black,
                  title: Text('สถานะ'),
                  subtitle: Text('ดูสถานะการเข้าใช้งาน'),
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => status()));
                        },
                        child: Text("Enter")),
                  ],
                ),
              ],
            ),
            // Center(
            //   child: FutureBuilder(
            //       future: SessionManager().get("token"),
            //       builder: (context, snapshot) {
            //         print(snapshot);
            //         return Text(snapshot.hasData ? snapshot.data : 'Loading....');
            //       }),
            // ),

            // MaterialButton(
            //   color: Colors.red,
            //   child: Text('Logout',
            //       style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white)),
            //   onPressed: () {},
            // ),
          ),
        ),
      ),
    );
  }
}
