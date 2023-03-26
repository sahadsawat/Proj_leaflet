import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/location.dart';
import 'package:leaflet_application/models/seeobj.dart';
import 'package:leaflet_application/controller/seeobj_service.dart';
import 'package:form_field_validator/form_field_validator.dart';

class seeobj_db_screen extends StatefulWidget {
  //
  seeobj_db_screen() : super();

  final String title = 'FoundlostItemDataTable(จัดการข้อมูลพบเห็นสิ่งของ)';

  @override
  seeobj_db_screenState createState() => seeobj_db_screenState();
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

class Status {
  const Status(this.id, this.name);

  final String name;
  final String id;
}

class seeobj_db_screenState extends State<seeobj_db_screen> {
  late List<seeobj> _seeobj;
  late List<seeobj> _filterseeobj;

  late GlobalKey<ScaffoldState> _scaffoldKey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controller for the First Name TextField we are going to create.
  late TextEditingController _seeobjidController;
  late TextEditingController _seeobjnameController;
  // controller for the Last Name TextField we are going to create.

  late seeobj? _selectedseeobj;
  late bool _isUpdating;
  late String _titleProgress;
  //debounce
  final _debouncer = Debouncer(milliseconds: 500);
  //drop down
  String? _selectedlocatName;
  late List<location> _locatNameSelected;

  String? selectedstatus;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("รอการยืนยัน"), value: "0"),
      DropdownMenuItem(child: Text("รอเจ้าของมารับคืน"), value: "1"),
      DropdownMenuItem(child: Text("คืนเจ้าของแล้ว"), value: "2"),
    ];
    return menuItems;
  }

  // List<Status> status = <Status>[
  //   const Status('0', 'รอการยืนยัน'),
  //   const Status('1', 'รอเจ้าของมารับคืน'),
  //   const Status('2', 'คืนเจ้าของแล้ว')
  // ];
  @override
  void initState() {
    super.initState();
    _seeobj = [];
    _filterseeobj = [];

    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _seeobjidController = TextEditingController();
    _seeobjnameController = TextEditingController();
    _locatNameSelected = [];
    _getlocation();
    _getseeobj();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // _addmajor() {
  //   if (_reportobjidController.text.isEmpty ||
  //       _reportobjnameController.text.isEmpty ||
  //       _selectedlocatName == null) {
  //     print('Empty Fields');
  //     return;
  //   }
  //   _showProgress('Adding reportbj...');
  //   repobj_service
  //       .addreportobj(
  //           _reportobjidController.text,
  //           _reportobjnameController.text,
  //           _selectedlocatName!,
  //           _selectedlocatName!,
  //           _selectedlocatName!,
  //           _selectedlocatName!,
  //           _selectedlocatName!)
  //       .then((result) {
  //     if ('success' == result) {
  //       _getreportobj(); // Refresh the List after adding each employee...
  //       _clearValues();
  //       // _getlocation();
  //     }
  //   });
  // }

  _getseeobj() {
    _showProgress('Loading seeobj...');
    seeobj_service.getseeobj().then((seeobj) {
      setState(() {
        _seeobj = seeobj;
        _filterseeobj = seeobj;
      });
      _clearValues();
      _showProgress(widget.title); // Reset the title...
      print("Lengthseeobj ${seeobj.length}");
    });
  }

  _getlocation() {
    _showProgress('Loading seeobj...');
    seeobj_service.getlocation().then((location) {
      setState(() {
        _locatNameSelected = location;
      });
      _clearValues();
      _showProgress(widget.title); // Reset the title...
      print("Lengthlocation ${location.length}");
    });
  }

  _updateseeobj(seeobj seeobj) {
    if (_seeobjnameController.text.isEmpty || _selectedseeobj == null) {
      print('Empty Fields');
      return;
    }
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating seeobj...');
    seeobj_service
        .updateseeobj(
            seeobj.Seeobj_id, _seeobjnameController.text, selectedstatus!)
        .then((result) {
      if ('success' == result) {
        _getseeobj(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteseeobj(seeobj seeobj) {
    _showProgress('Deleting seeobj...');
    seeobj_service.deleteseeobj(seeobj.Seeobj_id).then((result) {
      if ('success' == result) {
        _getseeobj(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _seeobjidController.text = '';
    _seeobjnameController.text = '';
    selectedstatus = null;
    _isUpdating = false;
  }

  _showValues(seeobj seeobj) {
    _seeobjidController.text = seeobj.Seeobj_id;
    _seeobjnameController.text = seeobj.Seeobj_name;
    _locatNameSelected == _selectedlocatName;
    dropdownItems == selectedstatus;
  }

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('FOUND NAME'),
            ),
            // DataColumn(
            //   label: Text('LOCATION NAME'),
            // ),
            DataColumn(
              label: Text('Status'),
            ),
            DataColumn(
              label: Text('USER EMAIL'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _filterseeobj
              .map(
                (seeobj) => DataRow(
                  cells: [
                    DataCell(
                      Text(seeobj.Seeobj_id),
                      // Add tap in the row and populate the
                      // textfields with the corresponding values to update
                      onTap: () {
                        _showValues(seeobj);
                        // Set the Selected employee to Update
                        _selectedseeobj = seeobj;
                        _selectedlocatName = seeobj.Locat_id;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        seeobj.Seeobj_name.toUpperCase(),
                      ),
                      onTap: () {
                        _showValues(seeobj);
                        // Set the Selected employee to Update
                        _selectedseeobj = seeobj;
                        _selectedlocatName = seeobj.Locat_id;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    // DataCell(
                    //   Text(
                    //     reportobj.Locat_name.toUpperCase(),
                    //   ),
                    //   onTap: () {
                    //     _showValues(reportobj);
                    //     // Set the Selected employee to Update
                    //     _selectedreportobj = reportobj;
                    //     _selectedlocatName = reportobj.Locat_id;
                    //     // Set flag updating to true to indicate in Update Mode
                    //     setState(() {
                    //       _isUpdating = true;
                    //     });
                    //   },
                    // ),
                    DataCell(
                      Text(
                        seeobj.Seeobj_status,
                      ),
                      onTap: () {
                        _showValues(seeobj);
                        // Set the Selected employee to Update
                        _selectedseeobj = seeobj;
                        _selectedlocatName = seeobj.Locat_id;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        seeobj.User_email,
                      ),
                      onTap: () {
                        _showValues(seeobj);
                        // Set the Selected employee to Update
                        _selectedseeobj = seeobj;
                        _selectedlocatName = seeobj.Locat_id;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteseeobj(seeobj);
                      },
                    ))
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

// Let's add a searchfield to search in the DataTable.
  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: 'Filter found lose item name',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          // Filter the original List and update the Filter list
          _debouncer.run(() {
            setState(() {
              _filterseeobj = _seeobj
                  .where((u) => (u.Seeobj_name.toString()
                      .toLowerCase()
                      .contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getseeobj();
              _getlocation();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.all(20.0),
                  //   child: TextFormField(
                  //     controller: _reportobjidController,
                  //     keyboardType: TextInputType.number,
                  //     decoration: InputDecoration.collapsed(
                  //       hintText: 'Report Number',
                  //     ),
                  //     validator: RequiredValidator(
                  //         errorText: "please record Report number"),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _seeobjnameController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Found item Name',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record Report Name"),
                    ),
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.all(20.0),
                  //     child: DropdownButtonFormField(
                  //       isExpanded: true,
                  //       hint: const Text("Select location"),
                  //       value: _selectedlocatName,
                  //       autovalidateMode: AutovalidateMode.always,
                  //       validator: (value) =>
                  //           (value == null) ? 'Please Select location' : null,
                  //       items: _locatNameSelected.map((reportobj) {
                  //         return DropdownMenuItem(
                  //           value: reportobj.Locat_id.toString(),
                  //           child: Text(reportobj.Locat_name),
                  //         );
                  //       }).toList(),
                  //       onChanged: (String? reportobj) {
                  //         setState(() {
                  //           _selectedlocatName = reportobj!;
                  //         });
                  //       },
                  //     )),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        hint: const Text("Select Status"),
                        value: selectedstatus,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) =>
                            (value == null) ? 'Please Select Status' : null,
                        items: dropdownItems,
                        onChanged: (status) {
                          setState(() {
                            selectedstatus = status;
                          });
                        },
                      )),
                ],
              ),
            ),
            _isUpdating
                ? Row(
                    children: <Widget>[
                      OutlinedButton(
                        child: Text('UPDATE'),
                        onPressed: () {
                          _updateseeobj(_selectedseeobj!);
                        },
                      ),
                      OutlinedButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                : Container(),
            searchField(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (formKey.currentState!.validate()) {
      //       _addmajor();
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
