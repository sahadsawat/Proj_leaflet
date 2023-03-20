import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/major.dart';
import 'package:leaflet_application/models/major2.dart';
import 'package:leaflet_application/controller/ma_service.dart';
import 'package:form_field_validator/form_field_validator.dart';

class major_screen extends StatefulWidget {
  //
  major_screen() : super();

  final String title = 'MajoryDataTable(สาขา)';

  @override
  major_screenState createState() => major_screenState();
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

class major_screenState extends State<major_screen> {
  late List<major> _major;
  late List<major> _filtermajor;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controller for the First Name TextField we are going to create.
  late TextEditingController _majornoController;
  late TextEditingController _majornameController;
  // controller for the Last Name TextField we are going to create.

  late major? _selectedmajor;
  late bool _isUpdating;
  late String _titleProgress;
  //debounce
  final _debouncer = Debouncer(milliseconds: 500);
  //drop down
  String? _selectedFacName;
  late List<major2> _facnameSelected;
  @override
  void initState() {
    super.initState();
    _major = [];
    _filtermajor = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _majornoController = TextEditingController();
    _majornameController = TextEditingController();
    _facnameSelected = [];
    _getmajor2();
    _getmajor();
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

  _addmajor() {
    if (_majornoController.text.isEmpty ||
        _majornameController.text.isEmpty ||
        _selectedFacName == null) {
      print('Empty Fields');
      return;
    }
    _showProgress('Adding major...');
    major_service
        .addmajor(_majornoController.text, _majornameController.text,
            _selectedFacName!)
        .then((result) {
      if ('success' == result) {
        _getmajor(); // Refresh the List after adding each employee...
        _clearValues();
        _getmajor2();
      }
    });
  }

  _getmajor() {
    _showProgress('Loading major...');
    major_service.getmajor().then((major) {
      setState(() {
        _major = major;
        _filtermajor = major;
      });
      _clearValues();
      _showProgress(widget.title); // Reset the title...
      print("Length ${major.length}");
    });
  }

  _getmajor2() {
    _showProgress('Loading major...');
    major_service.getmajor2().then((major2) {
      setState(() {
        _facnameSelected = major2;
      });
      _clearValues();
      _showProgress(widget.title); // Reset the title...
      print("Length ${major2.length}");
    });
  }

  _updatemajor(major major) {
    if (_majornameController.text.isEmpty || _selectedFacName == null) {
      print('Empty Fields');
      return;
    }
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating major...');
    major_service
        .updatemajor(major.Major_id, _majornoController.text,
            _majornameController.text, _selectedFacName!)
        .then((result) {
      if ('success' == result) {
        _getmajor(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deletemajor(major major) {
    _showProgress('Deleting major...');
    major_service.deletemajor(major.Major_id).then((result) {
      if ('success' == result) {
        _getmajor(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _majornoController.text = '';
    _majornameController.text = '';
    _selectedFacName = null;
  }

  _showValues(major major) {
    _majornoController.text = major.Major_no;
    _majornameController.text = major.Major_name;
    // _facnameSelected == _selectedFacName;
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
              label: Text('MAJOR NAME'),
            ),
            DataColumn(
              label: Text('FACULTY NAME'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _filtermajor
              .map(
                (major) => DataRow(
                  cells: [
                    DataCell(
                      Text(major.Major_no),
                      // Add tap in the row and populate the
                      // textfields with the corresponding values to update
                      onTap: () {
                        _showValues(major);
                        // Set the Selected employee to Update
                        _selectedmajor = major;
                        _selectedFacName = major.Fac_id;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        major.Major_name.toUpperCase(),
                      ),
                      onTap: () {
                        _showValues(major);
                        // Set the Selected employee to Update
                        _selectedmajor = major;
                        _selectedFacName = major.Fac_id;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        major.Fac_name.toUpperCase(),
                      ),
                      onTap: () {
                        _showValues(major);
                        // Set the Selected employee to Update
                        _selectedmajor = major;
                        _selectedFacName = major.Fac_id;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletemajor(major);
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
          hintText: 'Filter by major',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          // Filter the original List and update the Filter list
          _debouncer.run(() {
            setState(() {
              _filtermajor = _major
                  .where((u) => (u.Major_name.toString()
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
              _getmajor();
              _getmajor2();
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
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _majornoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: 'major Number',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record Major number"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _majornameController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'major Name',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record Major Name"),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        hint: const Text("Select Faculty"),
                        value: _selectedFacName,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) =>
                            (value == null) ? 'Please Select Faculty' : null,
                        items: _facnameSelected.map((major2) {
                          return DropdownMenuItem(
                            value: major2.Fac_id.toString(),
                            child: Text(major2.Fac_name),
                          );
                        }).toList(),
                        onChanged: (String? major2) {
                          setState(() {
                            _selectedFacName = major2!;
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
                          _updatemajor(_selectedmajor!);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _addmajor();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// class DropdownButtonFaculty extends StatefulWidget {
//   const DropdownButtonFaculty({super.key});

//   @override
//   State<DropdownButtonFaculty> createState() => _DropdownButtonFaculty();
// }

// class _DropdownButtonFaculty extends State<DropdownButtonFaculty> {
//   Future getAllName() async {
//     var response = await http
//         .get(Uri.parse("http://10.0.2.2/LeafletDB/major_faclist_action.php"));
//     var jsonBody = response.body;
//     var jsonData = json.decode(jsonBody);

//     if (response.body.isNotEmpty) {
//       json.decode(response.body);
//     }
//     setState(() {
//       list = jsonData;
//     });
//     print(jsonData);
//     return "success1";
//   }

//   String? dropdownValue;
//   List list = [];
//   @override
//   void initState() {
//     super.initState();
//     getAllName();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: dropdownValue,
//       items: list.map((list) {
//         return DropdownMenuItem(
//           child: Text(list['fac_name']),
//           value: list['fac_id'].toString(),
//         );
//       }).toList(),
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       isExpanded: true,
//       style: const TextStyle(
//         color: Colors.black,
//       ),
//       underline: Container(
//         height: 2,
//       ),
//       onChanged: (value) {
//         setState(() {
//           dropdownValue = value;
//         });
//       },
//     );
//   }
// }
