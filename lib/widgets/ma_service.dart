import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/major.dart';
import 'package:leaflet_application/models/major2.dart';

class major_service {
  static const String ROOT = 'http://10.0.2.2/LeafletDB/major_action.php';
  //test
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _GET_ALL_ACTION2 = 'GET_ALL2';
  static const _ADD_MAJOR_ACTION = 'ADD_MAJOR';
  static const _UPDATE_MAJOR_ACTION = 'UPDATE_MAJOR';
  static const _DELETE_MAJOR_ACTION = 'DELETE_MAJOR';

  static Future<List<major>> getmajor() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getmajor Response: ${response.body}');
      if (200 == response.statusCode) {
        List<major> list = parseResponse(response.body);
        return list;
      } else {
        return <major>[];
      }
    } catch (e) {
      return <major>[]; // return an empty list on exception/error
    }
  }

  static Future<List<major2>> getmajor2() async {
    try {
      var map2 = Map<String, dynamic>();
      map2['action'] = _GET_ALL_ACTION2;
      final response2 = await http.post(Uri.parse(ROOT), body: map2);
      print('getfaculty Response: ${response2.body}');
      if (200 == response2.statusCode) {
        List<major2> list2 = parseResponse2(response2.body);
        return list2;
      } else {
        return <major2>[];
      }
    } catch (e) {
      return <major2>[]; // return an empty list on exception/error
    }
  }

  static List<major> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<major>((json) => major.fromJson(json)).toList();
  }

  static List<major2> parseResponse2(String responseBody2) {
    final parsed2 = json.decode(responseBody2).cast<Map<String, dynamic>>();
    return parsed2.map<major2>((json) => major2.fromJson(json)).toList();
  }

  // Method to add major to the database...
  static Future<String> addmajor(
      String major_no, String major_name, String fac_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_MAJOR_ACTION;
      map['major_no'] = major_no;
      map['major_name'] = major_name;
      map['fac_id'] = fac_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addmajor Response: ${response.body}');
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

  // Method to update an major in Database...
  static Future<String> updatemajor(String major_id, String major_no,
      String major_name, String fac_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_MAJOR_ACTION;
      map['major_id'] = major_id;
      map['major_no'] = major_no;
      map['major_name'] = major_name;
      map['fac_id'] = fac_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updatemajor Response: ${response.body}');
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

  // Method to Delete an major from Database...
  static Future<String> deletemajor(String major_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_MAJOR_ACTION;
      map['major_id'] = major_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deletemajor Response: ${response.body}');
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
