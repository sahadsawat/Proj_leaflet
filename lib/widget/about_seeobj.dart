import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leaflet_application/models/seeobjmodel.dart';

class Aboutseeobj extends StatefulWidget {
  final seeobjmodel? seeobjModel;
  Aboutseeobj({Key? key, this.seeobjModel}) : super(key: key);
  @override
  _AboutseeobjState createState() => _AboutseeobjState();
}

class _AboutseeobjState extends State<Aboutseeobj> {
  seeobjmodel? seeobjModel;
  String? distanceString;

  @override
  void initState() {
    super.initState();
    seeobjModel = widget.seeobjModel;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16.0),
                width: 150.0,
                height: 150.0,
                child: Image.network(
                  'http://10.0.2.2/LeafletDB/seeimage/${seeobjModel!.urlPathImage}',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ListTile(
            // leading: Icon(Icons.home),
            title: Text(seeobjModel!.Seeobj_name),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(seeobjModel!.Seeobj_detail),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(seeobjModel!.Seeobj_date),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(seeobjModel!.Cate_name),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(seeobjModel!.Locat_name),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(seeobjModel!.User_email),
          ),
        ],
      ),
    );
  }
}
