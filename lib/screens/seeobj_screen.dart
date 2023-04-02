import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';
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
import 'package:leaflet_application/controller/seeobj_service.dart';
import 'package:leaflet_application/models/location.dart';
import 'package:dio/dio.dart';
import 'package:leaflet_application/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class seeobj_screen extends StatefulWidget {
  @override
  _seeobj_screenState createState() => _seeobj_screenState();
}

class _seeobj_screenState extends State<seeobj_screen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController seeobjname = TextEditingController();
  TextEditingController seeobjcate = TextEditingController();
  TextEditingController seeobjdetail = TextEditingController();
  TextEditingController seeobjphoto = TextEditingController();
  late String? seeobjdate;
  String? _selectedcateName;
  late List<category> _catenameSelected;
  String? _selectedlocatName;
  late List<location> _locatnameSelected;

  io.File? fileimage;
  String? imagedata;

  // late SharedPreferences logindata;
  // String? userid;

  @override
  void initState() {
    super.initState();
    _catenameSelected = [];
    _locatnameSelected = [];
    _getcate();
    _getlocat();
  }

  _addseeobj() async {
    String urlUpload = '${MyConstant().domain}/LeafletDB/saveimage2.php';
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'seeobj$i.jpg';
    Map<String, dynamic> map = Map();
    map['file'] =
        await MultipartFile.fromFile(fileimage!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);
    await Dio().post(urlUpload, data: formData);
    String urlPathImage = '$nameFile';
    print(
        'urlPathImage = ${MyConstant().domain}/LeafletDB/seeimage/$urlPathImage');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString('user_id');
    if (seeobjname.text.isEmpty) {
      print('Empty Fields');

      return;
    }
    seeobj_service
        .addseeobj(seeobjname.text, urlPathImage, seeobjdetail.text,
            seeobjdate!, _selectedcateName!, _selectedlocatName!, userid!)
        .then((result) {
      if ('success' == result) {
        Fluttertoast.showToast(
            msg: "SEEOBJ Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(
          context,
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

//v1

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        fileimage = io.File(object!.path);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        title: Text(
          'เพิ่มสิ่งของที่พบเห็น',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
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
                      'Found lose Items',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Found item name',
                        // prefixIcon: Icon(
                        //   Icons.email,
                        // ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      controller: seeobjname,
                      validator: RequiredValidator(
                          errorText: "please record found item name"),
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
                      controller: seeobjdetail,
                      validator:
                          RequiredValidator(errorText: "please record detail"),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        isExpanded: true,
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
                            seeobjdate = time!;
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
                      child: fileimage == null
                          ? Image.asset('images/leaf.png')
                          : Image.file(fileimage!),
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
                          _addseeobj();
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
