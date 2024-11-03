import 'dart:convert';

import 'package:http/http.dart' as http;

class PrescriptionRepository {
  Future<dynamic> createPrescription({required String prescription}) async {
    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/prescriptions/create/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: prescription,
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

  Future<dynamic> createMedicine({required String medicine}) async {
    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/medicines/create/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: medicine,
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

  Future<dynamic> createKeywords({required String keyword}) async {
    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/keywords/create/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: keyword,
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
}
