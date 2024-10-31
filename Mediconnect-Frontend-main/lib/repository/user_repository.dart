import 'dart:convert';

import 'package:mediconnect/models/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  Future<dynamic> createUser({required String user}) async {
    try {
      var response = await http.post(
          Uri.parse("http://10.0.2.2:8000/api/users/create/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: user);
      final data = jsonDecode(response.body);
      if (data == null) {
        return {"status": "error", "message": "Something went wrong"};
      } else {
        return data;
      }
    } catch (error) {
      print("Error: " + error.toString());
    }
  }

  Future<dynamic> loginUser({required String user}) async {
    try {
      var response = await http.post(
          Uri.parse("http://10.0.2.2:8000/api/users/login/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: user);
      final data = jsonDecode(response.body);
      if (data == null) {
        return {"status": "error", "message": "Something went wrong"};
      } else {
        return data;
      }
    } catch (error) {
      print("Error: " + error.toString());
    }
  }

   Future<dynamic> changeRegStatus({required String id}) async {
    try {
      var response = await http.put(
          Uri.parse('http://10.0.2.2:8000/api/users/$id/update-registration/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{"empty": "empty"}));
      final data = jsonDecode(response.body);
      if (data == null) {
        return {"status": "error", "message": "Something went wrong"};
      } else {
        return data;
      }
    } catch (error) {
      print("Error: " + error.toString());
    }
  }

Future<dynamic> changeRole({required String id, required String role}) async {
    try {
      var response = await http.put(
          Uri.parse('http://10.0.2.2:8000/api/users/$id/update-role/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{"Role": role}));
      final data = jsonDecode(response.body);
      if (data == null) {
        return {"status": "error", "message": "Something went wrong"};
      } else {
        return data;
      }
    } catch (error) {
      print("Error: " + error.toString());
    }
  }

}
