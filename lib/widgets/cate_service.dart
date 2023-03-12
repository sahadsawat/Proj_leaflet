import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/category.dart';

class cate_service {
  static const String ROOT = 'http://10.0.2.2/LeafletDB/category_action.php';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_CATE_ACTION = 'ADD_CATE';
  static const _UPDATE_CATE_ACTION = 'UPDATE_CATE';
  static const _DELETE_CATE_ACTION = 'DELETE_CATE';

  static Future<List<category>> getcategory() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getcategory Response: ${response.body}');
      if (200 == response.statusCode) {
        List<category> list = parseResponse(response.body);
        return list;
      } else {
        return <category>[];
      }
    } catch (e) {
      return <category>[]; // return an empty list on exception/error
    }
  }

  static List<category> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<category>((json) => category.fromJson(json)).toList();
  }

  // Method to add category to the database...
  static Future<String> addcategory(String cate_name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_CATE_ACTION;
      map['cate_name'] = cate_name;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addCategory Response: ${response.body}');
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
  static Future<String> updatecategory(String cate_id, String cate_name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_CATE_ACTION;
      map['cate_id'] = cate_id;
      map['cate_name'] = cate_name;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updatecategory Response: ${response.body}');
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
  static Future<String> deletecategory(String cate_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_CATE_ACTION;
      map['cate_id'] = cate_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deletecategory Response: ${response.body}');
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
