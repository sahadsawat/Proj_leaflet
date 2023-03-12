import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/location.dart';

class locat_service {
  static const String ROOT = 'http://10.0.2.2/LeafletDB/location_action.php';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_LOCAT_ACTION = 'ADD_LOCAT';
  static const _UPDATE_LOCAT_ACTION = 'UPDATE_LOCAT';
  static const _DELETE_LOCAT_ACTION = 'DELETE_LOCAT';

  static Future<List<location>> getlocation() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getlocation Response: ${response.body}');
      if (200 == response.statusCode) {
        List<location> list = parseResponse(response.body);
        return list;
      } else {
        return <location>[];
      }
    } catch (e) {
      return <location>[]; // return an empty list on exception/error
    }
  }

  static List<location> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<location>((json) => location.fromJson(json)).toList();
  }

  // Method to add category to the database...
  static Future<String> addlocation(String locat_name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_LOCAT_ACTION;
      map['locat_name'] = locat_name;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addLocation Response: ${response.body}');
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

  // Method to update an location in Database...
  static Future<String> updatelocation(
      String locat_id, String locat_name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_LOCAT_ACTION;
      map['locat_id'] = locat_id;
      map['locat_name'] = locat_name;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateLocation Response: ${response.body}');
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

  // Method to Delete an Location from Database...
  static Future<String> deletelocation(String locat_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_LOCAT_ACTION;
      map['locat_id'] = locat_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deletelocation Response: ${response.body}');
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
