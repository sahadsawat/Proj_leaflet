import 'dart:convert';
import 'package:leaflet_application/DashBoard.dart';
import 'package:leaflet_application/screens/edit_seeobj_user.dart';
import 'package:leaflet_application/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/seeobjmodel.dart';
import 'package:leaflet_application/screens/showseeobjmenuuser.dart';
import 'package:leaflet_application/models/user.dart';

class ShowListSeeobjUser extends StatefulWidget {
  @override
  _ShowListSeeobjUserState createState() => _ShowListSeeobjUserState();
}

class _ShowListSeeobjUserState extends State<ShowListSeeobjUser> {
  List<seeobjmodel>? seeobjModels;
  List<Widget>? seeobjCards;
  bool loadStatus = true;
  bool status = true;
  @override
  void initState() {
    super.initState();
    seeobjModels = [];
    seeobjCards = [];
    readseeobj();
  }

  Future<Null> readseeobj() async {
    if (seeobjModels!.length != 0) {
      loadStatus = true;
      status = true;
      seeobjModels!.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString('user_id');
    String url =
        '${MyConstant().domain}/LeafletDB/getSeeobjWhereUser.php?isAdd=true&user_id=$userid';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        int index = 0;
        for (var map in result) {
          seeobjmodel seeobj = seeobjmodel.fromJson(map);
          String seeobjname = seeobj.Seeobj_name;
          if (seeobjname.isNotEmpty) {
            // print('seeobjname = ${seeobj.Seeobj_name}');
            setState(() {
              seeobjModels!.add(seeobj);
              seeobjCards!.add(createCard(seeobj, index));

              index++;
            });
          }
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Widget createCard(seeobjmodel seeobjModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => Showseeobjmenuuser(
            seeobjModel: seeobjModels![index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: FittedBox(
                fit: BoxFit.cover,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${MyConstant().domain}/LeafletDB/seeimage/${seeobjModel.urlPathImage}'),
                  backgroundColor: Colors.transparent,
                  minRadius: 50,
                  maxRadius: 75,
                ),
              ),
              textColor: Colors.black,
              title: Text(seeobjModel.Seeobj_name),
              subtitle: Text(seeobjModel.Seeobj_date),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => EditSeeobjUser(
                        seeobjModel: seeobjModels![index],
                      ),
                    );
                    Navigator.push(context, route)
                        .then((value) => readseeobj());
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => deleteseeobj(seeobjModels![index]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? MyStyle().showProgress() : showContent(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListseeobj()
        : Center(
            child: Text('ยังไม่มีรายการ'),
          );
  }

  Widget showListseeobj() => GridView.count(
        crossAxisCount: 1,
        childAspectRatio: (1 / 0.5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: seeobjCards!,
      );

  Future<Null> deleteseeobj(seeobjmodel seeobjModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle()
            .showTitleH2('คุณต้องการลบ ข้อมูล ${seeobjModel.Seeobj_name} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${MyConstant().domain}/LeafletDB/deleteSeeobjWhereId.php?isAdd=true&seeobj_id=${seeobjModel.Seeobj_id}';
                  await Dio().get(url).then((value) => readseeobj());
                },
                child: Text('ยืนยัน'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยังไม่ลบ'),
              )
            ],
          )
        ],
      ),
    );
  }
}

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green;

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  TextStyle mainTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.purple,
  );

  TextStyle mainH2Title = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.green.shade700,
  );

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/$namePic'),
        fit: BoxFit.cover,
      ),
    );
  }

  SizedBox mySizebox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );

  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  Text showTitleH3(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.w500,
        ),
      );

  Text showTitleH3White(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      );

  Text showTitleH3Red(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red.shade900,
          fontWeight: FontWeight.w500,
        ),
      );

  Text showTitleH3Purple(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.purple.shade700,
          fontWeight: FontWeight.w500,
        ),
      );

  // Container showLogo() {
  //   return Container(
  //     width: 120.0,
  //     child: Image.asset('images/logo.png'),
  //   );
  // }

  MyStyle();
}
