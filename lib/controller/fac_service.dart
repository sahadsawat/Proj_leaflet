import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/faculty.dart';

class fac_service {
  static const String ROOT = 'http://10.0.2.2/LeafletDB/faculty_action.php';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_FAC_ACTION = 'ADD_FAC';
  static const _UPDATE_FAC_ACTION = 'UPDATE_FAC';
  static const _DELETE_FAC_ACTION = 'DELETE_FAC';

  static Future<List<faculty>> getfaculty() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getfaculty Response: ${response.body}');
      if (200 == response.statusCode) {
        List<faculty> list = parseResponse(response.body);
        return list;
      } else {
        return <faculty>[];
      }
    } catch (e) {
      return <faculty>[]; // return an empty list on exception/error
    }
  }

  static List<faculty> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<faculty>((json) => faculty.fromJson(json)).toList();
  }

  // Method to add category to the database...
  static Future<String> addfaculty(String fac_no, String fac_name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_FAC_ACTION;
      map['fac_no'] = fac_no;
      map['fac_name'] = fac_name;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addfaculty Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      print(e);
      return "error2";
    }
  }

  // Method to update an category in Database...
  static Future<String> updatefaculty(
      String fac_id, String fac_no, String fac_name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_FAC_ACTION;
      map['fac_id'] = fac_id;
      map['fac_no'] = fac_no;
      map['fac_name'] = fac_name;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updatefaculty Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      print(e);
      return "error2";
    }
  }

  // Method to Delete an category from Database...
  static Future<String> deletefaculty(String fac_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_FAC_ACTION;
      map['fac_id'] = fac_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deletefaculty Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "error2"; // returning just an "error" string to keep this simple...
    }
  }
}
