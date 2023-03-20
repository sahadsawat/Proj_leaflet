import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leaflet_application/screens/alldb_screens.dart';
import 'package:leaflet_application/screens/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'DashBoard.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dynamic token = SessionManager().get('token');
  runApp(
    MaterialApp(
      home: token != '' ? DashBoard() : MyApp(),
    ),
  );
}

// void main() {
//   runApp(
//     MyApp(),
//   );
// }

// class HomeApp extends StatelessWidget {
//   const HomeApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: alldbscreens(),
//     );
//   }
// }
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leaflet Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController useremail = TextEditingController();
  TextEditingController password = TextEditingController();

  Future login() async {
    var url = "http://10.0.2.2/LeafletDB/login_action.php";
    var response = await http.post(Uri.parse(url), body: {
      "user_email": useremail.text,
      "user_password": password.text,
    });
    var data = json.decode(response.body);
    if (data == "Success") {
      await SessionManager().set('token', useremail.text);
      Fluttertoast.showToast(
          msg: "Login successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoard(),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Leaflet Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        height: 300,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'User E-mail',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                controller: useremail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                controller: password,
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
                      login();
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
            )
          ],
        ),
      ),
    );
  }
}
