import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:leaflet_application/main.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
              future: SessionManager().get('token'),
              builder: (context, snapshot) {
                print(snapshot);
                return Text(snapshot.hasData ? snapshot.data : 'Loading....');
              }),
          MaterialButton(
            color: Colors.red,
            child: Text('Logout',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            onPressed: () {
              SessionManager().set('token', '');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
