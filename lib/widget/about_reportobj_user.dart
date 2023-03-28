import 'package:flutter/material.dart';
import 'package:leaflet_application/models/reportobjmodel.dart';
import 'package:leaflet_application/screens/edit_repobj_user.dart';

class Aboutrepobjuser extends StatefulWidget {
  final reportobjmodel? repobjModel;
  Aboutrepobjuser({Key? key, this.repobjModel}) : super(key: key);
  @override
  _AboutrepobjuserState createState() => _AboutrepobjuserState();
}

class _AboutrepobjuserState extends State<Aboutrepobjuser> {
  reportobjmodel? repobjModel;
  String? distanceString;
  List<reportobjmodel>? repobjModels;

  @override
  void initState() {
    super.initState();
    repobjModel = widget.repobjModel;
    repobjModels = [];
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
            leading: Icon(Icons.home),
            title: Text("ชื่อของที่แจ้าหา"),
            subtitle: Text(repobjModel!.Repobj_name,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          ListTile(
            leading: Icon(Icons.details),
            title: Text("รายละเอียด"),
            subtitle: Text(repobjModel!.Repobj_detail),
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text("เวลาที่ของหาย"),
            subtitle: Text(repobjModel!.Repobj_date),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("ประเภท หมวดหมู่"),
            subtitle: Text(repobjModel!.Cate_name),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text("สถานที่"),
            subtitle: Text(repobjModel!.Locat_name),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Emailผู้แจ้งหา"),
            subtitle: Text(repobjModel!.User_email),
          ),
        ],
      ),
    );
  }
}
