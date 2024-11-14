import 'dart:convert';

import 'package:http/http.dart' as http;

class AppointmentRepository {
  Future<dynamic> createAppointment({required String appointment}) async {
    try {
      var response = await http.post(
        Uri.parse("http://13.49.21.193:8000/api/appointments/create/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: appointment,
      );

      print(response.body); // Print to see if there's a specific error message
      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body); // Successful response
      } else {
        return {"status": "error", "message": jsonDecode(response.body)};
      }
    } catch (error) {
      print("Error: " + error.toString());
      return {"status": "error", "message": error.toString()};
    }
  }

  Future<dynamic> updateAppointment(
      {required String appointment, required int apId}) async {
    try {
      var response = await http.put(
        Uri.parse("http://13.49.21.193:8000/api/appointments/$apId/update/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: appointment,
      );

      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body); // Successful response
      } else {
        return {"status": "error", "message": jsonDecode(response.body)};
      }
    } catch (error) {
      print("Error: " + error.toString());
      return {"status": "error", "message": error.toString()};
    }
  }

  Future<dynamic> deleteAppointment({required int apId}) async {
    try {
      var response = await http.delete(
        Uri.parse("http://13.49.21.193:8000/api/appointments/$apId/delete/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({"some": "some"}),
      );

      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": jsonDecode(response.body)};
      }
    } catch (error) {
      print("Error: " + error.toString());
      return {"status": "error", "message": error.toString()};
    }
  }
}
