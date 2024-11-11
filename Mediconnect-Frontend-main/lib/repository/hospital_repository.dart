import 'dart:convert';

import 'package:http/http.dart' as http;

class HospitalRepository {
  Future<dynamic> createHospital({required String hospital}) async {
    try {
      var response = await http.post(
          Uri.parse("http://13.60.21.117:8000/api/hospitals/create/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: hospital);
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
