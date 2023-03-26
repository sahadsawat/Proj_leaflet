import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/reportobj.dart';
import 'package:leaflet_application/models/location.dart';
import 'package:leaflet_application/models/seeobj.dart';

class seeobj_service {
  static const String ROOT = 'http://10.0.2.2/LeafletDB/seeobj_action.php';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _GET_ALL_ACTION2 = 'GET_ALL2';
  static const _ADD_SEEOBJ_ACTION = 'ADD_SEEOBJ';
  static const _UPDATE_SEEOBJ_ACTION = 'UPDATE_SEEOBJ';
  static const _UPDATE_SEEOBJ_ACTION2 = 'UPDATE_SEEOBJ2';
  static const _DELETE_SEEOBJ_ACTION = 'DELETE_SEEOBJ';

  static Future<List<seeobj>> getseeobj() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getseeobj Response: ${response.body}');
      if (200 == response.statusCode) {
        List<seeobj> list = parseResponse(response.body);
        return list;
      } else {
        return <seeobj>[];
      }
    } catch (e) {
      return <seeobj>[]; // return an empty list on exception/error
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

  static List<seeobj> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<seeobj>((json) => seeobj.fromJson(json)).toList();
  }

  static List<location> parseResponse2(String responseBody2) {
    final parsed2 = json.decode(responseBody2).cast<Map<String, dynamic>>();
    return parsed2.map<location>((json) => location.fromJson(json)).toList();
  }

  // Method to add category to the database...
  static Future addseeobj(
      String Seeobj_name,
      String urlPathImage,
      // String repobj_status,
      String Seeobj_detail,
      String Seeobj_date,
      String Cate_id,
      String Locat_id,
      String User_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_SEEOBJ_ACTION;
      map['seeobj_name'] = Seeobj_name;
      map['seeobj_photo'] = urlPathImage;
      // map['reportobj_status'] = repobj_status;
      map['seeobj_detail'] = Seeobj_detail;
      map['seeobj_date'] = Seeobj_date;
      map['cate_id'] = Cate_id;
      map['locat_id'] = Locat_id;
      map['user_id'] = User_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addseeobj Response: ${response.body}');
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
  static Future<dynamic> updateseeobj(
    String Seeobj_id,
    String Seeobj_name,
    // String Repobj_photo,
    String Seeobj_status,
    // String Repobj_detail,
    // String Repobj_date,
    // String Cate_id,
    // String Locat_id,
    // String User_id
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_SEEOBJ_ACTION2;
      map['seeobj_id'] = Seeobj_id;
      map['seeobj_name'] = Seeobj_name;
      // map['reportobj_photo'] = Repobj_photo;
      map['seeobj_status'] = Seeobj_status;
      // map['reportobj_detail'] = Repobj_detail;
      // map['reportobj_date'] = Repobj_date;
      // map['cat_id'] = Cate_id;
      // map['locat_id'] = Locat_id;
      // map['user_id'] = User_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateseeobj Response: ${response.body}');
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
  static Future<String> deleteseeobj(String Seeobj_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_SEEOBJ_ACTION;
      map['seeobj_id'] = Seeobj_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deleteseeobj Response: ${response.body}');
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
