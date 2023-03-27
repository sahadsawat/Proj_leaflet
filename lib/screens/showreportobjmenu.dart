import 'package:flutter/material.dart';
import 'package:leaflet_application/models/reportobjmodel.dart';
import 'package:leaflet_application/widget/about_reportobj.dart';
import 'package:leaflet_application/widget/show_list_repobj_all.dart';

class Showrepobjmenu extends StatefulWidget {
  final reportobjmodel? repobjModel;
  Showrepobjmenu({Key? key, this.repobjModel}) : super(key: key);
  @override
  _ShowrepobjmenuState createState() => _ShowrepobjmenuState();
}

class _ShowrepobjmenuState extends State<Showrepobjmenu> {
  reportobjmodel? repobjModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    repobjModel = widget.repobjModel;
    listWidgets.add(Aboutrepobj(
      repobjModel: repobjModel,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        title: Text(repobjModel!.Repobj_name),
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
    );
  }
}
