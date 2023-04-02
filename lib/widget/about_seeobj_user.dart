import 'package:flutter/material.dart';
import 'package:leaflet_application/models/seeobjmodel.dart';
import 'package:leaflet_application/utility/my_constant.dart';

class Aboutseeobjuser extends StatefulWidget {
  final seeobjmodel? seeobjModel;
  Aboutseeobjuser({Key? key, this.seeobjModel}) : super(key: key);
  @override
  _AboutseeobjuserState createState() => _AboutseeobjuserState();
}

class _AboutseeobjuserState extends State<Aboutseeobjuser> {
  seeobjmodel? seeobjModel;
  String? distanceString;
  List<seeobjmodel>? seeobjModels;

  @override
  void initState() {
    super.initState();
    seeobjModel = widget.seeobjModel;
    seeobjModels = [];
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
                  '${MyConstant().domain}/LeafletDB/seeimage/${seeobjModel!.urlPathImage}',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("ชื่อของที่ตามหา"),
            subtitle: Text(seeobjModel!.Seeobj_name,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          ListTile(
            leading: Icon(Icons.details),
            title: Text("รายละเอียด"),
            subtitle: Text(seeobjModel!.Seeobj_detail),
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text("เวลาที่ของหาย"),
            subtitle: Text(seeobjModel!.Seeobj_date),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("ประเภท หมวดหมู่"),
            subtitle: Text(seeobjModel!.Cate_name),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text("สถานที่"),
            subtitle: Text(seeobjModel!.Locat_name),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Emailผู้แจ้งหา"),
            subtitle: Text(seeobjModel!.User_email),
          ),
        ],
      ),
    );
  }
}
