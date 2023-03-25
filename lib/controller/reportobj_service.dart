import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/reportobj.dart';
import 'package:leaflet_application/models/location.dart';

class repobj_service {
  static const String ROOT = 'http://10.0.2.2/LeafletDB/reportobj_action.php';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _GET_ALL_ACTION2 = 'GET_ALL2';
  static const _ADD_REPOBJ_ACTION = 'ADD_REPOBJ';
  static const _UPDATE_REPOBJ_ACTION = 'UPDATE_REPOBJ';
  static const _UPDATE_REPOBJ_ACTION2 = 'UPDATE_REPOBJ2';
  static const _DELETE_REPOBJ_ACTION = 'DELETE_REPOBJ';

  static Future<List<reportobj>> getrepobj() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getrepobj Response: ${response.body}');
      if (200 == response.statusCode) {
        List<reportobj> list = parseResponse(response.body);
        return list;
      } else {
        return <reportobj>[];
      }
    } catch (e) {
      return <reportobj>[]; // return an empty list on exception/error
    }
  }

  static Future<List<location>> getlocation() async {
    try {
      var map2 = Map<String, dynamic>();
      map2['action'] = _GET_ALL_ACTION2;
      final response2 = await http.post(Uri.parse(ROOT), body: map2);
      print('getlocation Response: ${response2.body}');
      if (200 == response2.statusCode) {
        List<location> list2 = parseResponse2(response2.body);
        return list2;
      } else {
        return <location>[];
      }
    } catch (e) {
      return <location>[]; // return an empty list on exception/error
    }
  }

  static List<reportobj> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<reportobj>((json) => reportobj.fromJson(json)).toList();
  }

  static List<location> parseResponse2(String responseBody2) {
    final parsed2 = json.decode(responseBody2).cast<Map<String, dynamic>>();
    return parsed2.map<location>((json) => location.fromJson(json)).toList();
  }

  // Method to add category to the database...
  static Future addreportobj(
      String Repobj_name,
      String urlPathImage,
      // String repobj_status,
      String Repobj_detail,
      String Repobj_date,
      String Cate_id,
      String Locat_id,
      String User_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_REPOBJ_ACTION;
      map['reportobj_name'] = Repobj_name;
      map['reportobj_photo'] = urlPathImage;
      // map['reportobj_status'] = repobj_status;
      map['reportobj_detail'] = Repobj_detail;
      map['reportobj_date'] = Repobj_date;
      map['cate_id'] = Cate_id;
      map['locat_id'] = Locat_id;
      map['user_id'] = User_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addRepobj Response: ${response.body}');
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
  static Future<dynamic> updatereportobj(
    String Repobj_id,
    String Repobj_name,
    // String Repobj_photo,
    String Repobj_status,
    // String Repobj_detail,
    // String Repobj_date,
    // String Cate_id,
    // String Locat_id,
    // String User_id
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_REPOBJ_ACTION2;
      map['reportobj_id'] = Repobj_id;
      map['reportobj_name'] = Repobj_name;
      // map['reportobj_photo'] = Repobj_photo;
      map['reportobj_status'] = Repobj_status;
      // map['reportobj_detail'] = Repobj_detail;
      // map['reportobj_date'] = Repobj_date;
      // map['cat_id'] = Cate_id;
      // map['locat_id'] = Locat_id;
      // map['user_id'] = User_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updatereportobj Response: ${response.body}');
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
  static Future<String> deletereportobj(String repobj_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_REPOBJ_ACTION;
      map['reportobj_id'] = repobj_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deletereportobj Response: ${response.body}');
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
