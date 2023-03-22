import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:leaflet_application/main.dart';
import 'package:leaflet_application/screens/alldb_screens.dart';
import 'package:leaflet_application/screens/userprofile_screen.dart';

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
  List<Widget> widgetList = [
    DashBoard(),
    Center(
      child: Text('กราฟ', style: kTextStyle),
    ),
    userprofile_screen(),
    alldbscreens(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Screen'),
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
            label: "กราฟ",
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
        title: Text('Wellcome'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              SessionManager().destroy();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Text('ยินดีต้อนรับ'),
          ),
          Center(
            child: FutureBuilder(
                future: SessionManager().get("token"),
                builder: (context, snapshot) {
                  print(snapshot);
                  return Text(snapshot.hasData ? snapshot.data : 'Loading....');
                }),
          ),
          // MaterialButton(
          //   color: Colors.red,
          //   child: Text('Logout',
          //       style: TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white)),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
