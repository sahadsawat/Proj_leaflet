import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leaflet_application/DashBoard.dart';
import 'package:leaflet_application/models/category.dart';
import 'package:leaflet_application/controller/cate_service.dart';
import 'package:leaflet_application/controller/locat_service.dart';
import 'package:leaflet_application/controller/reportobj_service.dart';
import 'package:leaflet_application/models/location.dart';

class reportobj_screen extends StatefulWidget {
  @override
  _reportobj_screenState createState() => _reportobj_screenState();
}

class _reportobj_screenState extends State<reportobj_screen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController repobjname = TextEditingController();
  TextEditingController repobjcate = TextEditingController();
  TextEditingController repobjdetail = TextEditingController();
  TextEditingController repobjphoto = TextEditingController();

  String? repobjtime;

  String? _selectedcateName;
  late List<category> _catenameSelected;

  String? _selectedlocatName;
  late List<location> _locatnameSelected;
  File? file;

  @override
  void initState() {
    super.initState();
    _catenameSelected = [];
    _locatnameSelected = [];
    _getcate();
    _getlocat();
  }

  // Future reportobj() async {
  //   var url = "http://10.0.2.2/LeafletDB/reportobj_action.php";
  //   var response = await http.post(Uri.parse(url), body: {
  //     "reportobj_name": repobjname.text,
  //     "cat_id": _selectedcateName,
  //     // "reportobj_date": repobjtime,
  //     "reportobj_detail": repobjdetail.text,
  //     "locat_id": _selectedlocatName,
  //     // "reportobj_photo": repobjphoto.text,
  //   });
  //   if (response.body.isNotEmpty) {
  //     json.decode(response.body);
  //   }
  //   var data = json.decode(response.body);
  //   if (data == "Success") {
  //     Fluttertoast.showToast(
  //         msg: "ADD reportOBJ Successful",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => DashBoard(),
  //       ),
  //     );
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "E-mail and password is valid",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  _addreportobj() {
    if (repobjname.text.isEmpty) {
      print('Empty Fields');

      return;
    }
    repobj_service
        .addreportobj(repobjname.text, repobjdetail.text, repobjtime!,
            _selectedcateName!, _selectedlocatName!)
        .then((result) {
      if ('success' == result) {
        Fluttertoast.showToast(
            msg: "ReportOBJ Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    });
  }

  _getcate() {
    _selectedcateName = null;
    cate_service.getcategory().then((category) {
      setState(() {
        _catenameSelected = category;
      });
    });
    setState(() {
      _catenameSelected = [];
    });
  }

  _getlocat() {
    _selectedlocatName = null;
    locat_service.getlocation().then((locat) {
      setState(() {
        _locatnameSelected = locat;
      });
    });
    setState(() {
      _locatnameSelected = [];
    });
  }

  // groupImage() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       child: Row(
  //         children: <Widget>[
  //           Text(
  //             "chang image",
  //             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.add_photo_alternate),
  //             onPressed: () => chooseImage(ImageSource.gallery),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.add_a_photo),
  //             onPressed: () => chooseImage(ImageSource.camera),
  //           ),
  //           Container(
  //             width: 200.0,
  //             height: 200.0,
  //             child: file == null
  //                 ? Image.asset('images/leaf.png')
  //                 : Image.file(file!),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แจ้งตามหาสิ่งของ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Report OBJ',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'objName',
                        // prefixIcon: Icon(
                        //   Icons.email,
                        // ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      controller: repobjname,
                      validator:
                          RequiredValidator(errorText: "please record objname"),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          // prefixIcon: Icon(
                          //   Icons.,
                          // ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        value: _selectedcateName,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) =>
                            (value == null) ? 'Please Select Category' : null,
                        items: _catenameSelected.map((cate) {
                          return DropdownMenuItem(
                            value: cate.Cate_id.toString(),
                            child: Text(cate.Cate_name),
                          );
                        }).toList(),
                        onChanged: (String? cate) {
                          setState(() {
                            _selectedcateName = cate!;
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Detail',
                        // prefixIcon: Icon(
                        //   Icons.email,
                        // ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      controller: repobjdetail,
                      validator:
                          RequiredValidator(errorText: "please record detail"),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Location',
                          // prefixIcon: Icon(
                          //   Icons.,
                          // ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        value: _selectedlocatName,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) =>
                            (value == null) ? 'Please Select Location' : null,
                        items: _locatnameSelected.map((locat) {
                          return DropdownMenuItem(
                            value: locat.Locat_id.toString(),
                            child: Text(locat.Locat_name),
                          );
                        }).toList(),
                        onChanged: (String? locat) {
                          setState(() {
                            _selectedlocatName = locat!;
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      child: DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: "วันที่",
                        timeLabelText: "เวลา",
                        onChanged: (String? time) {
                          setState(() {
                            repobjtime = time!;
                            print(time);
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Select image ->",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_photo_alternate),
                            onPressed: () => chooseImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      child: file == null
                          ? Image.asset('images/leaf.png')
                          : Image.file(file!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.green,
                      child: Text('SAVE DATA',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // reportobj();
                          _addreportobj();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
