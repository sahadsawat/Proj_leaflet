import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/user.dart';
import 'package:leaflet_application/controller/user_service.dart';
import 'package:form_field_validator/form_field_validator.dart';

class user_screen extends StatefulWidget {
  //
  user_screen() : super();

  final String title = 'UserDataTable(ผู้ใช้)';

  @override
  user_screenState createState() => user_screenState();
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

class user_screenState extends State<user_screen> {
  late List<user> _user;
  late List<user> _filteruser;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controller for the First Name TextField we are going to create.
  late TextEditingController _useridController;
  late TextEditingController _useremailController;
  // controller for the Last Name TextField we are going to create.
  late user _selecteduser;
  late bool _isUpdating;
  late String _titleProgress;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _user = [];
    _filteruser = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _useridController = TextEditingController();
    _useremailController = TextEditingController();
    _getuser();
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

  _adduser() {
    if (_useridController.text.isEmpty || _useremailController.text.isEmpty) {
      print('Empty Fields');

      return;
    }
    _showProgress('Adding user...');
    user_service
        .adduser(_useridController.text, _useremailController.text)
        .then((result) {
      if ('success' == result) {
        _getuser(); // Refresh the List after adding each employee...
        _clearValues();
      }
    });
  }

  _getuser() {
    _showProgress('Loading user...');
    user_service.getuser().then((user) {
      setState(() {
        _user = user;
        _filteruser = user;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${user.length}");
    });
  }

  _updateuser(user user) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating user...');
    user_service
        .updateuser(
            user.User_id,
            _useremailController.text,
            _useridController.text,
            _useridController.text,
            _useridController.text,
            _useridController.text,
            _useridController.text,
            _useridController.text
            )
        .then((result) {
      if ('success' == result) {
        _getuser(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteuser(user user) {
    _showProgress('Deleting user...');
    user_service.deleteuser(user.User_id).then((result) {
      if ('success' == result) {
        _getuser(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _useridController.text = '';
    _useremailController.text = '';
  }

  _showValues(user user) {
    _useridController.text = user.User_id;
    _useremailController.text = user.User_email;
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
              label: Text('User_Email'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _filteruser
              .map(
                (user) => DataRow(
                  cells: [
                    DataCell(
                      Text(user.User_id),
                      // Add tap in the row and populate the
                      // textfields with the corresponding values to update
                      onTap: () {
                        _showValues(user);
                        // Set the Selected employee to Update
                        _selecteduser = user;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        user.User_email,
                      ),
                      onTap: () {
                        _showValues(user);
                        // Set the Selected employee to Update
                        _selecteduser = user;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteuser(user);
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
          hintText: 'Filter by User',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          // Filter the original List and update the Filter list
          _debouncer.run(() {
            setState(() {
              _filteruser = _user
                  .where((u) => (u.User_id.toString()
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
              _getuser();
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
                      controller: _useridController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: 'User ID',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record user ID"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _useremailController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'User E-mail',
                      ),
                      validator:
                          RequiredValidator(errorText: "please record user email"),
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
                          _updateuser(_selecteduser);
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
            _adduser();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
