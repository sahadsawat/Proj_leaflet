import 'package:flutter/material.dart';
import 'package:leaflet_application/models/seeobjmodel.dart';
import 'package:leaflet_application/widget/about_seeobj_user.dart';
import 'package:leaflet_application/widget/show_list_seeobj_user.dart';

class Showseeobjmenuuser extends StatefulWidget {
  final seeobjmodel? seeobjModel;
  Showseeobjmenuuser({Key? key, this.seeobjModel}) : super(key: key);
  @override
  _ShowseeobjmenuuserState createState() => _ShowseeobjmenuuserState();
}

class _ShowseeobjmenuuserState extends State<Showseeobjmenuuser> {
  seeobjmodel? seeobjModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    seeobjModel = widget.seeobjModel;
    listWidgets.add(Aboutseeobjuser(
      seeobjModel: seeobjModel,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        title: Text(seeobjModel!.Seeobj_name),
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
    );
  }
}
