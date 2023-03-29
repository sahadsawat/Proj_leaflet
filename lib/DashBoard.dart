import 'package:flutter/material.dart';
import 'package:leaflet_application/main.dart';
import 'package:leaflet_application/screens/main_repobj.dart';
import 'package:leaflet_application/screens/main_seeobj_user.dart';
import 'package:leaflet_application/screens/main_repobj_user.dart';
import 'package:leaflet_application/screens/main_seeobj.dart';
import 'package:leaflet_application/screens/seeobj_screen.dart';
import 'package:leaflet_application/status.dart';
import 'package:leaflet_application/screens/alldb_screens.dart';
import 'package:leaflet_application/screens/userprofile_screen.dart';
import 'package:leaflet_application/screens/reportobj_screen.dart';
import '../widget/show_list_repobj_all.dart';

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

  Widget? currentWidget;

  void initState() {
    super.initState();
    innitial();
    currentWidget = ShowListRepobjAll();
  }

  void innitial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userid = logindata.getString('user_id');
      useremail = logindata.getString('user_email');
      userfirstname = logindata.getString('first_name');
    });
  }

  List<Widget> widgetList = [
    DashBoard(),
    MainReportobj(),
    MainSeeobj(),
    alldbscreens(),
  ];

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 10, 185, 100),
      ),
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

  ListTile showuserreportobj() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => MainReportobjUser(),
        );
        Navigator.push(context, route);
      },
      leading: Icon(
        Icons.view_list,
      ),
      title: Text('แสดงข้อมูลแจ้งหาของหายของผู้ใช้'),
      subtitle: Text(''),
    );
  }

  ListTile showuserseeobj() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => MainSeeobjUser(),
        );
        Navigator.push(context, route);
      },
      leading: Icon(
        Icons.view_list,
      ),
      title: Text('แสดงข้อมูลพบเจอของหายของผู้ใช้'),
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

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                showuserprofile(),
                showuserreportobj(),
                showuserseeobj(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      body: Center(
        child: widgetList.elementAt(itemIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
            backgroundColor: Color.fromARGB(255, 10, 185, 100),
          ),
          BottomNavigationBarItem(
            label: "AllReport",
            icon: Icon(Icons.graphic_eq),
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            label: "Allfound",
            icon: Icon(
              Icons.graphic_eq,
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
      backgroundColor: Color.fromARGB(255, 219, 254, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 10, 185, 100),
        centerTitle: true,
        title: Text('LeafLet Application'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.logout,
          //     color: Colors.white,
          //   ),
          //   onPressed: () async {
          //     SharedPreferences prefernces =
          //         await SharedPreferences.getInstance();
          //     prefernces.clear();
          //     Navigator.of(context).pushAndRemoveUntil(
          //         MaterialPageRoute(
          //             builder: (BuildContext context) => LoginPage()),
          //         (route) => false);
          //   },
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Card(
            color: Color.fromARGB(255, 255, 200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.push_pin,
                    size: 50.0,
                    color: Colors.black,
                  ),
                  textColor: Colors.black,
                  title: Text(
                    'หน้าแจ้งของหายของคุณ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('แจ้งหาของหาย'),
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainReportobjUser()));
                        },
                        child: Text("Enter")),
                  ],
                ),
                SizedBox(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.push_pin,
                    size: 50.0,
                    color: Colors.black,
                  ),
                  textColor: Colors.black,
                  title: Text(
                    'หน้าพบของหายของคุณ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('พบของหาย'),
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainSeeobjUser()));
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
