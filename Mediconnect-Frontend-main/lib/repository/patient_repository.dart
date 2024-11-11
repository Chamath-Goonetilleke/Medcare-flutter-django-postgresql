import 'dart:convert';

import 'package:http/http.dart' as http;

class PatientRepository {
  Future<dynamic> createPatient({required String patient}) async {
    try {
      var response = await http.post(
          Uri.parse("http://13.60.21.117:8000/api/patient/create/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: patient);
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