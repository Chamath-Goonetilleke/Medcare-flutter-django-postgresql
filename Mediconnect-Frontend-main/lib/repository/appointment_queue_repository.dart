import 'dart:convert';

import 'package:http/http.dart' as http;

class AppointmentQueueRepository {
  Future<dynamic> createAppointmentQueue(
      {required String appointmentQueue}) async {
    try {
      var response = await http.post(
        Uri.parse("http://13.49.21.193:8000/api/appointment-queues/create/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: appointmentQueue,
      );
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
}
