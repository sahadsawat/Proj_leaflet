import 'package:flutter/material.dart';
import 'package:leaflet_application/models/seeobjmodel.dart';
import 'package:leaflet_application/widget/about_seeobj.dart';
import 'package:leaflet_application/widget/show_list_seeobj_all.dart';

class Showseeobjmenu extends StatefulWidget {
  final seeobjmodel? seeobjModel;
  Showseeobjmenu({Key? key, this.seeobjModel}) : super(key: key);
  @override
  _ShowseeobjmenuState createState() => _ShowseeobjmenuState();
}

class _ShowseeobjmenuState extends State<Showseeobjmenu> {
  seeobjmodel? seeobjModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    seeobjModel = widget.seeobjModel;
    listWidgets.add(Aboutseeobj(
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
