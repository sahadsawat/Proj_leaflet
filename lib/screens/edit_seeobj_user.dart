import 'dart:io' as io;
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leaflet_application/DashBoard.dart';
import 'package:leaflet_application/models/category.dart';
import 'package:leaflet_application/models/location.dart';
import 'package:leaflet_application/models/seeobjmodel.dart';
import 'package:leaflet_application/controller/cate_service.dart';
import 'package:leaflet_application/controller/locat_service.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:date_time_picker/date_time_picker.dart';

// import 'package:ungfood/utility/normal_dialog.dart';

class EditSeeobjUser extends StatefulWidget {
  final seeobjmodel? seeobjModel;
  EditSeeobjUser({Key? key, this.seeobjModel}) : super(key: key);

  @override
  _EditSeeobjUserState createState() => _EditSeeobjUserState();
}

class _EditSeeobjUserState extends State<EditSeeobjUser> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textseeobjname = TextEditingController();
  TextEditingController textseeobjdetail = TextEditingController();

  late String? seeobjdate;

  String? _selectedcateName;
  late List<category> _catenameSelected;

  String? _selectedlocatName;
  late List<location> _locatnameSelected;

  String? seeobjstatus = "1";

  seeobjmodel? seeobjModel;
  io.File? fileimage;
  String? seeobjname, seeobjdetail, urlPathImage;
  String? imagedata;

  @override
  void initState() {
    super.initState();
    seeobjModel = widget.seeobjModel;
    textseeobjname.text = seeobjModel!.Seeobj_name;
    textseeobjdetail.text = seeobjModel!.Seeobj_detail;
    seeobjname = seeobjModel!.Seeobj_name;
    seeobjdetail = seeobjModel!.Seeobj_detail;
    urlPathImage = seeobjModel!.urlPathImage;
    _selectedcateName = seeobjModel!.Cate_id;
    _selectedlocatName = seeobjModel!.Locat_id;
    seeobjdate = seeobjModel!.Seeobj_date;
    _catenameSelected = [];
    _locatnameSelected = [];
    _getcate();
    _getlocat();
  }

  _getcate() {
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
    locat_service.getlocation().then((locat) {
      setState(() {
        _locatnameSelected = locat;
      });
    });
    setState(() {
      _locatnameSelected = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล${seeobjModel!.Seeobj_name}'),
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
                      'Found lose Item',
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
                      controller: textseeobjname,
                      onChanged: (value) {
                        setState(() => seeobjname = value);
                      },
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
                      controller: textseeobjdetail,
                      onChanged: (value) {
                        setState(() => seeobjdetail = value);
                      },
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
                        initialValue: seeobjdate.toString(),
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
                  groupImage(),
                ],
              ),
            )),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (seeobjname!.isEmpty || seeobjdetail!.isEmpty) {
          // normalDialog(context, 'กรุณากรอกให้ครบ ทุกช่องคะ');
        } else {
          confirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการจะ เปลี่ยนแปลงข้อมูลใช่หรือไม่?'),
        children: <Widget>[
          Row(
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('เปลี่ยนแปลง'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ไม่เปลี่ยนแปลง'),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editValueOnMySQL() async {
    if (fileimage != null) {
      String urlUpload = 'http://10.0.2.2/LeafletDB/saveimage2.php';
      Random random = Random();
      int i = random.nextInt(1000000);
      String? nameFile = 'seeobj$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(fileimage!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);
      await Dio().post(urlUpload, data: formData);
      String urlPathImage = '$nameFile';
      print('urlPathImage = http://10.0.2.2/LeafletDB/seeimage/$urlPathImage');
      String seeobjid = seeobjModel!.Seeobj_id;
      String userid = seeobjModel!.User_id;
      String url =
          'http://10.0.2.2/LeafletDB/editSeeobjWhereId.php?isAdd=true&seeobj_id=$seeobjid&seeobj_name=$seeobjname&seeobj_photo=$urlPathImage&seeobj_status=$seeobjstatus&seeobj_detail=$seeobjdetail&seeobj_date=$seeobjdate&cate_id=$_selectedcateName&locat_id=$_selectedlocatName&user_id=$userid';
      await Dio().get(url).then((value) {
        if (value.toString() == 'true') {
          Navigator.pop(
            context,
          );
        }
      });
    } else {
      String seeobjid = seeobjModel!.Seeobj_id;
      String userid = seeobjModel!.User_id;
      String url =
          'http://10.0.2.2/LeafletDB/editSeeobjWhereId.php?isAdd=true&seeobj_id=$seeobjid&seeobj_name=$seeobjname&seeobj_photo=$urlPathImage&seeobj_status=$seeobjstatus&seeobj_detail=$seeobjdetail&seeobj_date=$seeobjdate&cate_id=$_selectedcateName&locat_id=$_selectedlocatName&user_id=$userid';
      await Dio().get(url).then((value) {
        if (value.toString() == 'true') {
          Navigator.pop(
            context,
          );
        } else {
          // normalDialog(context, 'กรุณาลองใหม่ มีอะไร ? ผิดพลาด');
        }
      });
    }
  }

  Widget groupImage() => Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            width: 200.0,
            height: 200.0,
            child: fileimage == null
                ? Image.network(
                    'http://10.0.2.2/LeafletDB/seeimage/${seeobjModel!.urlPathImage}',
                    fit: BoxFit.cover,
                  )
                : Image.file(fileimage!),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      );

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
}
