import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leaflet_application/models/category.dart';
import 'package:leaflet_application/widgets/cate_service.dart';
import 'package:form_field_validator/form_field_validator.dart';

class category_screen extends StatefulWidget {
  //
  category_screen() : super();

  final String title = 'CategoryDataTable(หมวดหมู่)';

  @override
  category_screenState createState() => category_screenState();
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

class category_screenState extends State<category_screen> {
  late List<category> _category;
  late List<category> _filtercategory;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controller for the First Name TextField we are going to create.
  late TextEditingController _catenoController;
  late TextEditingController _catenameController;
  // controller for the Last Name TextField we are going to create.
  late category _selectedcategory;
  late bool _isUpdating;
  late String _titleProgress;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _category = [];
    _filtercategory = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _catenoController = TextEditingController();
    _catenameController = TextEditingController();
    _getcategory();
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

  _addcategory() {
    if (_catenoController.text.isEmpty || _catenameController.text.isEmpty) {
      print('Empty Fields');

      return;
    }
    _showProgress('Adding Category...');
    cate_service
        .addcategory(_catenoController.text, _catenameController.text)
        .then((result) {
      if ('success' == result) {
        _getcategory(); // Refresh the List after adding each employee...
        _clearValues();
      }
    });
  }

  _getcategory() {
    _showProgress('Loading category...');
    cate_service.getcategory().then((category) {
      setState(() {
        _category = category;
        _filtercategory = category;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${category.length}");
    });
  }

  _updatecategory(category category) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating category...');
    cate_service
        .updatecategory(
            category.Cate_id, _catenoController.text, _catenameController.text)
        .then((result) {
      if ('success' == result) {
        _getcategory(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deletecategory(category category) {
    _showProgress('Deleting category...');
    cate_service.deletecategory(category.Cate_id).then((result) {
      if ('success' == result) {
        _getcategory(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _catenoController.text = '';
    _catenameController.text = '';
  }

  _showValues(category category) {
    _catenoController.text = category.Cate_no;
    _catenameController.text = category.Cate_name;
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
              label: Text('CATEGORY NAME'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _filtercategory
              .map(
                (category) => DataRow(
                  cells: [
                    DataCell(
                      Text(category.Cate_no),
                      // Add tap in the row and populate the
                      // textfields with the corresponding values to update
                      onTap: () {
                        _showValues(category);
                        // Set the Selected employee to Update
                        _selectedcategory = category;
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(
                      Text(
                        category.Cate_name.toUpperCase(),
                      ),
                      onTap: () {
                        _showValues(category);
                        // Set the Selected employee to Update
                        _selectedcategory = category;
                        // Set flag updating to true to indicate in Update Mode
                        setState(() {
                          _isUpdating = true;
                        });
                      },
                    ),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletecategory(category);
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
          hintText: 'Filter by Category',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          // Filter the original List and update the Filter list
          _debouncer.run(() {
            setState(() {
              _filtercategory = _category
                  .where((u) => (u.Cate_name.toString()
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
              _getcategory();
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
                      controller: _catenoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Category Number',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record category number"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _catenameController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Category Name',
                      ),
                      validator: RequiredValidator(
                          errorText: "please record category name"),
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
                          _updatecategory(_selectedcategory);
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
            _addcategory();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
