import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/faculty.dart';
import 'package:leaflet_application/controller/fac_service.dart';
import 'package:form_field_validator/form_field_validator.dart';

class faculty_screen extends StatefulWidget {
  //
  faculty_screen() : super();

  final String title = 'FacultyDataTable(คณะ)';

  @override
  faculty_screenState createState() => faculty_screenState();
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

class faculty_screenState extends State<faculty_screen> {
  late List<faculty> _faculty;
  late List<faculty> _filterfaculty;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controller for the First Name TextField we are going to create.
  late TextEditingController _facnoController;
  late TextEditingController _facnameController;
  // controller for the Last Name TextField we are going to create.
  late faculty _selectedfaculty;
  late bool _isUpdating;
  late String _titleProgress;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _faculty = [];
    _filterfaculty = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _facnoController = TextEditingController();
    _facnameController = TextEditingController();
    _getfaculty();
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

  _addfaculty() {
    if (_facnoController.text.isEmpty || _facnameController.text.isEmpty) {
      print('Empty Fields');

      return;
    }
    _showProgress('Adding faculty...');
    fac_service
        .addfaculty(_facnoController.text, _facnameController.text)
        .then((result) {
      if ('success' == result) {
        _getfaculty(); // Refresh the List after adding each employee...
        _clearValues();
      }
    });
  }

  _getfaculty() {
    _showProgress('Loading faculty...');
    fac_service.getfaculty().then((faculty) {
      setState(() {
        _faculty = faculty;
        _filterfaculty = faculty;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${faculty.length}");
    });
  }

  _updatefaculty(faculty faculty) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating faculty...');
    fac_service
        .updatefaculty(
            faculty.Fac_id, _facnoController.text, _facnameController.text)
        .then((result) {
      if ('success' == result) {
        _getfaculty(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deletefaculty(faculty faculty) {
    _showProgress('Deleting faculty...');
    fac_service.deletefaculty(faculty.Fac_id).then((result) {
      if ('success' == result) {
        _getfaculty(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _facnoController.text = '';
    _facnameController.text = '';
  }

  _showValues(faculty faculty) {
    _facnoController.text = faculty.Fac_no;
    _facnameController.text = faculty.Fac_name;
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
              label: Text('FACULTY NAME'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _filterfaculty
              .map(
                (faculty) => DataRow(
                  cells: [
                    DataCell(
                      Text(faculty.Fac_no),
                      // Add tap in the row and populate the
                      // textfields with the corresponding values to update
                      onTap: () {
                        _showValues(faculty);
                        // Set the Selected employee to Update
                        _selectedfaculty = faculty;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        faculty.Fac_name.toUpperCase(),
                      ),
                      onTap: () {
                        _showValues(faculty);
                        // Set the Selected employee to Update
                        _selectedfaculty = faculty;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletefaculty(faculty);
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
          hintText: 'Filter by faculty',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          // Filter the original List and update the Filter list
          _debouncer.run(() {
            setState(() {
              _filterfaculty = _faculty
                  .where((u) => (u.Fac_name.toString()
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
              _getfaculty();
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
                      controller: _facnoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Faculty Number',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record Faculty number"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _facnameController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Faculty Name',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record Faculty name"),
                    ),
                  ),
                ],
              ),
            ),
            // Add an update button and a Cancel Button
            // show these buttons only when updating an employee
            _isUpdating
                ? Row(
                    children: <Widget>[
                      OutlinedButton(
                        child: Text('UPDATE'),
                        onPressed: () {
                          _updatefaculty(_selectedfaculty);
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
            _addfaculty();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:leaflet_application/models/faculty.dart';
// import 'package:leaflet_application/widgets/fac_service.dart';

// class faculty_screen extends StatefulWidget {
//   //
//   faculty_screen() : super();

//   final String title = 'FacultyDataTable(คณะ)';

//   @override
//   faculty_screenState createState() => faculty_screenState();
// }

// class Debouncer {
//   final int milliseconds;
//   VoidCallback? action;
//   Timer? _timer;

//   Debouncer({required this.milliseconds});

//   run(VoidCallback action) {
//     if (_timer?.isActive ?? false) {
//       _timer?.cancel();
//     }
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }

// class faculty_screenState extends State<faculty_screen> {
//   late List<faculty> _faculty;
//   late List<faculty> _filterfaculty;
//   late GlobalKey<ScaffoldState> _scaffoldKey;
//   // controller for the First Name TextField we are going to create.
//   late TextEditingController _facnameController;
//   // controller for the Last Name TextField we are going to create.
//   late faculty _selectedfaculty;
//   late bool _isUpdating;
//   late String _titleProgress;
//   final _debouncer = Debouncer(milliseconds: 500);

//   @override
//   void initState() {
//     super.initState();
//     _faculty = [];
//     _filterfaculty = [];
//     _isUpdating = false;
//     _titleProgress = widget.title;
//     _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
//     _facnameController = TextEditingController();
//     _getfaculty();
//   }

//   // Method to update title in the AppBar Title
//   _showProgress(String message) {
//     setState(() {
//       _titleProgress = message;
//     });
//   }

//   _showSnackBar(context, message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }

//   _addfaculty() {
//     if (_facnameController.text.isEmpty) {
//       print('Empty Fields');
//       return;
//     }
//     _showProgress('Adding faculty...');
//     fac_service.addfaculty(_facnameController.text).then((result) {
//       if ('success' == result) {
//         _getfaculty(); // Refresh the List after adding each employee...
//         _clearValues();
//       }
//     });
//   }

//   _getfaculty() {
//     _showProgress('Loading faculty...');
//     fac_service.getfaculty().then((faculty) {
//       setState(() {
//         _faculty = faculty;
//         _filterfaculty = faculty;
//       });
//       _showProgress(widget.title); // Reset the title...
//       print("Length ${faculty.length}");
//     });
//   }

//   _updatefaculty(faculty faculty) {
//     setState(() {
//       _isUpdating = true;
//     });
//     _showProgress('Updating faculty...');
//     fac_service
//         .updatefaculty(faculty.Fac_id, _facnameController.text)
//         .then((result) {
//       if ('success' == result) {
//         _getfaculty(); // Refresh the list after update
//         setState(() {
//           _isUpdating = false;
//         });
//         _clearValues();
//       }
//     });
//   }

//   _deletefaculty(faculty faculty) {
//     _showProgress('Deleting faculty...');
//     fac_service.deletefaculty(faculty.Fac_id).then((result) {
//       if ('success' == result) {
//         _getfaculty(); // Refresh after delete...
//       }
//     });
//   }

//   // Method to clear TextField values
//   _clearValues() {
//     _facnameController.text = '';
//   }

//   _showValues(faculty faculty) {
//     _facnameController.text = faculty.Fac_name;
//   }

//   // Let's create a DataTable and show the employee list in it.
//   SingleChildScrollView _dataBody() {
//     // Both Vertical and Horozontal Scrollview for the DataTable to
//     // scroll both Vertical and Horizontal...
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: [
//             DataColumn(
//               label: Text('ID'),
//             ),
//             DataColumn(
//               label: Text('FACULTY NAME'),
//             ),
//             // Lets add one more column to show a delete button
//             DataColumn(
//               label: Text('DELETE'),
//             )
//           ],
//           rows: _filterfaculty
//               .map(
//                 (faculty) => DataRow(
//                   cells: [
//                     DataCell(
//                       Text(faculty.Fac_id),
//                       // Add tap in the row and populate the
//                       // textfields with the corresponding values to update
//                       onTap: () {
//                         _showValues(faculty);
//                         // Set the Selected employee to Update
//                         _selectedfaculty = faculty;
//                         setState(() {
//                           _isUpdating = true;
//                         });
//                       },
//                     ),
//                     DataCell(
//                       Text(
//                         faculty.Fac_name.toUpperCase(),
//                       ),
//                       onTap: () {
//                         _showValues(faculty);
//                         // Set the Selected employee to Update
//                         _selectedfaculty = faculty;
//                         // Set flag updating to true to indicate in Update Mode
//                         setState(() {
//                           _isUpdating = true;
//                         });
//                       },
//                     ),
//                     DataCell(IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         _deletefaculty(faculty);
//                       },
//                     ))
//                   ],
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }

// // Let's add a searchfield to search in the DataTable.
//   searchField() {
//     return Padding(
//       padding: EdgeInsets.all(20.0),
//       child: TextField(
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.all(5.0),
//           hintText: 'Filter by faculty',
//         ),
//         onChanged: (string) {
//           // We will start filtering when the user types in the textfield.
//           // Run the debouncer and start searching
//           // Filter the original List and update the Filter list
//           _debouncer.run(() {
//             setState(() {
//               _filterfaculty = _faculty
//                   .where((u) => (u.Fac_name.toString()
//                       .toLowerCase()
//                       .contains(string.toLowerCase())))
//                   .toList();
//             });
//           });
//         },
//       ),
//     );
//   }

//   // UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text(_titleProgress), // we show the progress in the title...
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               _getfaculty();
//             },
//           )
//         ],
//       ),
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.all(20.0),
//               child: TextField(
//                 controller: _facnameController,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'Faculty Name',
//                 ),
//               ),
//             ),
//             // Add an update button and a Cancel Button
//             // show these buttons only when updating an employee
//             _isUpdating
//                 ? Row(
//                     children: <Widget>[
//                       OutlinedButton(
//                         child: Text('UPDATE'),
//                         onPressed: () {
//                           _updatefaculty(_selectedfaculty);
//                         },
//                       ),
//                       OutlinedButton(
//                         child: Text('CANCEL'),
//                         onPressed: () {
//                           setState(() {
//                             _isUpdating = false;
//                           });
//                           _clearValues();
//                         },
//                       ),
//                     ],
//                   )
//                 : Container(),
//             searchField(),
//             Expanded(
//               child: _dataBody(),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addfaculty();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
