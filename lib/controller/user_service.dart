import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:leaflet_application/models/user.dart';
import 'package:leaflet_application/utility/my_constant.dart';

class user_service {
  static String ROOT = '${MyConstant().domain}/LeafletDB/user_action.php';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  // static const _ADD_USER_ACTION = 'ADD_USER';
  static const _UPDATE_USER_ACTION = 'UPDATE_USER';
  static const _DELETE_USER_ACTION = 'DELETE_USER';

  static Future<List<User>> getuser() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getuser Response: ${response.body}');
      if (200 == response.statusCode) {
        List<User> list = parseResponse(response.body);
        return list;
      } else {
        return <User>[];
      }
    } catch (e) {
      return <User>[]; // return an empty list on exception/error
    }
  }

  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  // Method to update an category in Database...
  static Future<String> updateuser(
    String user_id,
    String user_email,
    String user_tel,
    // String user_password,
    // String first_name,
    // String last_name,
    // String user_tel,
    // String user_lineid,
    // String major_id
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_USER_ACTION;
      map['user_id'] = user_id;
      map['user_email'] = user_email;
      map['user_tel'] = user_tel;
      // map['user_password'] = user_password;
      // map['first_name'] = first_name;
      // map['last_name'] = last_name;
      // map['user_tel'] = user_tel;
      // map['user_lineid'] = user_lineid;
      // map['major_id'] = major_id;

      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateUser Response: ${response.body}');
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

  static Future<String> updateuser2(
      String user_id,
      String user_email,
      String user_tel,
      String user_password,
      String first_name,
      String last_name,
      String user_lineid,
      String major_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_USER_ACTION;
      map['user_id'] = user_id;
      map['user_email'] = user_email;
      map['user_password'] = user_password;
      map['first_name'] = first_name;
      map['last_name'] = last_name;
      map['user_tel'] = user_tel;
      map['user_lineid'] = user_lineid;
      map['major_id'] = major_id;

      final response = await http.post(Uri.parse(ROOT), body: map);
      print('2updateUser Response: ${response.body}');
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
  static Future<String> deleteuser(String user_id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_USER_ACTION;
      map['user_id'] = user_id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deleteUser Response: ${response.body}');
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
