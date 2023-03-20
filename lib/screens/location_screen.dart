import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/location.dart';
import 'package:leaflet_application/controller/locat_service.dart';
import 'package:form_field_validator/form_field_validator.dart';

class location_screen extends StatefulWidget {
  //
  location_screen() : super();

  final String title = 'LocationDataTable(สถานที่)';

  @override
  location_screenState createState() => location_screenState();
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

class location_screenState extends State<location_screen> {
  late List<location> _location;
  late List<location> _filterlocation;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controller for the First Name TextField we are going to create.
  late TextEditingController _locatnoController;
  late TextEditingController _locatnameController;
  // controller for the Last Name TextField we are going to create.
  late location _selectedlocation;
  late bool _isUpdating;
  late String _titleProgress;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _location = [];
    _filterlocation = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _locatnoController = TextEditingController();
    _locatnameController = TextEditingController();
    _getlocation();
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

  _addlocation() {
    if (_locatnoController.text.isEmpty || _locatnameController.text.isEmpty) {
      print('Empty Fields');

      return;
    }
    _showProgress('Adding Category...');
    locat_service
        .addlocation(_locatnoController.text, _locatnameController.text)
        .then((result) {
      if ('success' == result) {
        _getlocation(); // Refresh the List after adding each employee...
        _clearValues();
      }
    });
  }

  _getlocation() {
    _showProgress('Loading category...');
    locat_service.getlocation().then((location) {
      setState(() {
        _location = location;
        _filterlocation = location;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${location.length}");
    });
  }

  _updatelocation(location location) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating category...');
    locat_service
        .updatelocation(location.Locat_id, _locatnoController.text,
            _locatnameController.text)
        .then((result) {
      if ('success' == result) {
        _getlocation(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deletelocation(location location) {
    _showProgress('Deleting category...');
    locat_service.deletelocation(location.Locat_id).then((result) {
      if ('success' == result) {
        _getlocation(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _locatnoController.text = '';
    _locatnameController.text = '';
  }

  _showValues(location location) {
    _locatnoController.text = location.Locat_no;
    _locatnameController.text = location.Locat_name;
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
              label: Text('LOCATION NAME'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _filterlocation
              .map(
                (location) => DataRow(
                  cells: [
                    DataCell(
                      Text(location.Locat_no),
                      // Add tap in the row and populate the
                      // textfields with the corresponding values to update
                      onTap: () {
                        _showValues(location);
                        // Set the Selected employee to Update
                        _selectedlocation = location;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        location.Locat_name.toUpperCase(),
                      ),
                      onTap: () {
                        _showValues(location);
                        // Set the Selected employee to Update
                        _selectedlocation = location;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletelocation(location);
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
          hintText: 'Filter by location',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          // Filter the original List and update the Filter list
          _debouncer.run(() {
            setState(() {
              _filterlocation = _location
                  .where((u) => (u.Locat_name.toString()
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
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _locatnoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Location Number',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record location number"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _locatnameController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Location Name',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record location name"),
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
                          _updatelocation(_selectedlocation);
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
            _addlocation();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
