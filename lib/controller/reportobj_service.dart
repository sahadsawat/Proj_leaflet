import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/reportobj.dart';

class repobj_service {
  static const String ROOT = 'http://10.0.2.2/LeafletDB/reportobj_action.php';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_REPOBJ_ACTION = 'ADD_REPOBJ';
  static const _UPDATE_REPOBJ_ACTION = 'UPDATE_REPOBJ';
  static const _DELETE_REPOBJ_ACTION = 'DELETE_REPOBJ';

  static Future<List<reportbj>> getrepobj() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getrepobj Response: ${response.body}');
      if (200 == response.statusCode) {
        List<reportbj> list = parseResponse(response.body);
        return list;
      } else {
        return <reportbj>[];
      }
    } catch (e) {
      return <reportbj>[]; // return an empty list on exception/error
    }
  }

  static List<reportbj> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<reportbj>((json) => reportbj.fromJson(json)).toList();
  }

  // Method to add category to the database...
  static Future<String> addreportobj(
    String Repobj_name,
    // String Repobj_photo,
    // String repobj_status,
    String repobj_detail,
    String repobj_date,
    String cate_id,
    String locat_id,
    // String user_id
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_REPOBJ_ACTION;
      map['reportobj_name'] = Repobj_name;
      // map['reportobj_photo'] = Repobj_photo;
      // map['reportobj_status'] = repobj_status;
      map['reportobj_detail'] = repobj_detail;
      map['reportobj_date'] = repobj_date;
      map['cate_id'] = cate_id;
      map['locat_id'] = locat_id;
      // map['user_id'] = user_id;
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
  static Future<String> updatereportobj(
      String repobj_id,
      String Repobj_name,
      String Repobj_photo,
      String repobj_status,
      String repobj_detail,
      String repobj_date,
      String cate_id,
      String locat_id,
      String user_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_REPOBJ_ACTION;
      map['reportobj_id'] = repobj_id;
      map['reportobj_name'] = Repobj_name;
      map['reportobj_photo'] = Repobj_photo;
      map['reportobj_status'] = repobj_status;
      map['reportobj_detail'] = repobj_detail;
      map['reportobj_date'] = repobj_date;
      map['cat_id'] = cate_id;
      map['locat_id'] = locat_id;
      map['user_id'] = user_id;
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