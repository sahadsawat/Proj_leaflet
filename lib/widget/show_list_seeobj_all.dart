import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/seeobjmodel.dart';
import 'package:leaflet_application/screens/showseeobjmenu.dart';
import 'package:leaflet_application/models/user.dart';

class ShowListSeeobjAll extends StatefulWidget {
  @override
  _ShowListSeeobjAllState createState() => _ShowListSeeobjAllState();
}

class _ShowListSeeobjAllState extends State<ShowListSeeobjAll> {
  List<seeobjmodel>? seeobjModels;
  List<Widget>? seeobjCards;

  @override
  void initState() {
    super.initState();
    seeobjModels = [];
    seeobjCards = [];
    readseeobj();
  }

  Future<Null> readseeobj() async {
    String url =
        'http://10.0.2.2/LeafletDB/getSeeobjWhereSeeobj.php?isAdd=true&seeobj_status=1';
    Response response = await Dio().get(url);
    // print('value = $value');
    var result = json.decode(response.data);
    int index = 0;
    for (var map in result) {
      seeobjmodel seeobj = seeobjmodel.fromJson(map);

      String seeobjname = seeobj.Seeobj_name;
      if (seeobjname.isNotEmpty) {
        // print('repobjname = ${repobj.Repobj_name}');
        setState(() {
          seeobjModels!.add(seeobj);
          seeobjCards!.add(createCard(seeobj, index));
          index++;
        });
      }
    }
  }

  Widget createCard(seeobjmodel seeobjModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => Showseeobjmenu(
            seeobjModel: seeobjModels![index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'http://10.0.2.2/LeafletDB/seeimage/${seeobjModel.urlPathImage}'),
              ),
            ),
            Container(width: 120, child: Text(seeobjModel.Seeobj_name)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return seeobjCards!.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 220.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: seeobjCards!,
          );
  }
}

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green;

  Widget iconShowCart(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_shopping_cart),
      onPressed: () {
        // MaterialPageRoute route = MaterialPageRoute(
        //   builder: (context) => ShowCart(),
        // );
        // Navigator.push(context, route);
      },
    );
  }

  Widget showProgress() {
    return Center(
        // child: CircularProgressIndicator(),
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
