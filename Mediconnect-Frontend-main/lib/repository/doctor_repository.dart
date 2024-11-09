import 'dart:convert';

import 'package:http/http.dart' as http;

class DoctorRepository {
  Future<dynamic> createDoctor({required String doctor}) async {
    try {
      var response = await http.post(
          Uri.parse("http://10.0.2.2:8000/api/doctors/create/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: doctor);
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

    Future<dynamic> updateDoctor({required int currentHos, required int docId}) async {
    try {
      var response = await http.patch(
          Uri.parse("http://10.0.2.2:8000/api/doctors/update_current_hospital/$docId/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({"Current_HOS_ID": currentHos}));
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

  Future<dynamic> updateDoctorRate(
      {required String doctor , required int docId}) async {
    try {
      var response = await http.patch(
          Uri.parse(
              "http://10.0.2.2:8000/api/doctors/update_current_hospital/$docId/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: doctor);
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
