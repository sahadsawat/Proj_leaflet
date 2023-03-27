import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leaflet_application/models/reportobjmodel.dart';

class Aboutrepobj extends StatefulWidget {
  final reportobjmodel? repobjModel;
  Aboutrepobj({Key? key, this.repobjModel}) : super(key: key);
  @override
  _AboutrepobjState createState() => _AboutrepobjState();
}

class _AboutrepobjState extends State<Aboutrepobj> {
  reportobjmodel? repobjModel;
  String? distanceString;

  @override
  void initState() {
    super.initState();
    repobjModel = widget.repobjModel;
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
                  'http://10.0.2.2/LeafletDB/reportimage/${repobjModel!.urlPathImage}',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ListTile(
            // leading: Icon(Icons.home),
            title: Text(repobjModel!.Repobj_name),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(repobjModel!.Repobj_detail),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(repobjModel!.Repobj_date),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(repobjModel!.Cate_name),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(repobjModel!.Locat_name),
          ),
          ListTile(
            // leading: Icon(Icons.phone),
            title: Text(repobjModel!.User_email),
          ),
        ],
      ),
    );
  }
}
