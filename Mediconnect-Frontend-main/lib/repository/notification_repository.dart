import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationRepository {
  Future<dynamic> createNotification({required String notification}) async {
    try {
      var response = await http.post(
          Uri.parse("http://13.49.21.193:8000/api/notes/create/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: notification);
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
