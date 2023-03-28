import 'package:flutter/material.dart';
import 'package:leaflet_application/models/reportobjmodel.dart';
import 'package:leaflet_application/widget/about_reportobj_user.dart';
import 'package:leaflet_application/widget/show_list_repobj_user.dart';

class Showrepobjmenuuser extends StatefulWidget {
  final reportobjmodel? repobjModel;
  Showrepobjmenuuser({Key? key, this.repobjModel}) : super(key: key);
  @override
  _ShowrepobjmenuuserState createState() => _ShowrepobjmenuuserState();
}

class _ShowrepobjmenuuserState extends State<Showrepobjmenuuser> {
  reportobjmodel? repobjModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    repobjModel = widget.repobjModel;
    listWidgets.add(Aboutrepobjuser(
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
