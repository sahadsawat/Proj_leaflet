import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/reportobj.dart';
import 'package:leaflet_application/models/reportobjmodel.dart';
import 'package:leaflet_application/screens/showreportobjmenu.dart';
import 'package:leaflet_application/controller/reportobj_service.dart';
import 'package:leaflet_application/utility/my_constant.dart';

class ShowListRepobjAll extends StatefulWidget {
  @override
  _ShowListRepobjAllState createState() => _ShowListRepobjAllState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ShowListRepobjAllState extends State<ShowListRepobjAll> {
  final _debouncer = Debouncer(milliseconds: 2000);
  List<reportobjmodel>? repobjModels;
  List<reportobj>? _filterrepobj;
  List<reportobj>? _repobj;

  List<Widget>? repobjCards;
  ScrollController scrollController = ScrollController();
  int amoutgrid = 6;

  final List<Map> myProducts =
      List.generate(100000, (index) => {"id": index, "name": "Product $index"})
          .toList();

  @override
  void initState() {
    super.initState();
    repobjModels = [];
    repobjCards = [];
    _filterrepobj = [];
    _repobj = [];
    readreportobj();

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     print('at the end');
    //     setState(() {
    //       amoutgrid = amoutgrid + 2;
    //     });
    //   }
    // });

    // _getrepobj();
  }

  // searchField() {
  //   return Padding(
  //     padding: EdgeInsets.all(20.0),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         contentPadding: EdgeInsets.all(5.0),
  //         hintText: 'Filter by Category',
  //       ),
  //       onChanged: (string) {
  //         _debouncer.run(() {
  //           setState(() {
  //             _filterrepobj = _repobj!
  //                 .where((u) => (u.Repobj_name.toString()
  //                     .toLowerCase()
  //                     .contains(string.toLowerCase())))
  //                 .toList();
  //           });
  //         });
  //       },
  //     ),
  //   );
  // }

  // _getrepobj() {
  //   repobj_service.getrepobj().then((repobj) {
  //     setState(() {
  //       _filterrepobj = repobj;
  //       _repobj = repobj;
  //     });
  //     print("Length ${repobj.length}");
  //   });
  // }

  // Future<void> readreportobj(index) async {
  //   String url =
  //       '${MyConstant().domain}/LeafletDB/getRepobjWhereRepobj.php?isAdd=true&reportobj_status=1';
  //   Response response = await Dio().get(url);
  //   print('value = $response');
  //   var result = json.decode(response.data);
  //   int index = 0;
  //   for (var map in result) {
  //     reportobjmodel repobj = reportobjmodel.fromJson(map);

  //     String repobjname = repobj.Repobj_name;
  //     if (repobjname.isNotEmpty) {
  //       // print('repobjname = ${repobj.Repobj_name}');
  //       _debouncer.run(() {
  //         setState(() {
  //           repobjModels!.add(repobj);
  //           repobjCards!.add(createCard(repobj, index));
  //           index++;
  //         });
  //       });
  //     }
  //   }
  // }
  Future<void> readreportobj() async {
    String url =
        '${MyConstant().domain}/LeafletDB/getRepobjWhereRepobj.php?isAdd=true&reportobj_status=1';
    Response response = await Dio().get(url);
    print('value = $response');
    var result = json.decode(response.data);
    int index = 0;
    for (var map in result) {
      reportobjmodel repobj = reportobjmodel.fromJson(map);

      String repobjname = repobj.Repobj_name;
      if (repobjname.isNotEmpty) {
        // print('repobjname = ${repobj.Repobj_name}');

        setState(() {
          repobjModels!.add(repobj);
          repobjCards!.add(createCard(repobj, index));
          index++;
          // repobjModels!.add(repobj);
        });
      }
    }
  }

  Widget createCard(reportobjmodel repobjModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => Showrepobjmenu(
            repobjModel: repobjModels![index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        // color: Color.fromARGB(255, 144, 255, 214),
        // shadowColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 65,
                backgroundImage: AssetImage('images/logo.png'),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      '${MyConstant().domain}/LeafletDB/reportimage/${repobjModel.urlPathImage}'),
                ),
              ),
            ),
            SizedBox(
                width: 120,
                child: Text(
                  repobjModel.Repobj_name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            SizedBox(width: 120, child: Text(repobjModel.Repobj_date)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // searchField(),
          SizedBox(
            height: 10,
          ),
          databody(),
        ],
      ),
    );
  }

  // Widget showimage(int index) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width *0.5,
  //     child: Image.network('${MyConstant().domain}/LeafletDB/reportimage/${repobjModel.urlPathImage}'),
  //   );
  // }

  // Widget showgridview(int index) {
  //   return Row(
  //     children: [],
  //   );
  // }

  // Widget show() {
  //   return GridView.builder(
  //       controller: scrollController,
  //       itemCount: amoutgrid,
  //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //           maxCrossAxisExtent: 200,
  //           childAspectRatio: 3 / 2,
  //           crossAxisSpacing: 20,
  //           mainAxisSpacing: 20),
  //       itemBuilder: (BuildContext ctx, index) {
  //         return showgridview(index);
  //       });
  // }

  databody() {
    return repobjCards!.length == 0
        ? MyStyle().showProgress()
        : GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            //     //     // .extent(
            //     //     //     scrollDirection: Axis.vertical,
            //     //     //     physics: NeverScrollableScrollPhysics(),
            //     //     //     shrinkWrap: true,
            //     //     //     padding: EdgeInsets.only(left: 20, right: 20),
            //     //     //     maxCrossAxisExtent: 220.0,
            //     //     //     mainAxisSpacing: 10.0,
            //     //     //     crossAxisSpacing: 10.0,
            children: repobjCards!,
          );
  }
}

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green;

  Widget showProgress() {
    return const Center(
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
