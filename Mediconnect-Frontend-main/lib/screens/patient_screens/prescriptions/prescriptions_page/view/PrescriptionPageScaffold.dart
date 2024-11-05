import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrescriptionsScaffold extends StatefulWidget {
  @override
  State<PrescriptionsScaffold> createState() => _PrescriptionsScaffoldState();
}

class _PrescriptionsScaffoldState extends State<PrescriptionsScaffold> {
  List<Map<String, dynamic>> myPrescriptions = [];
  String? _patientId;
  bool isLoading = true;
  void getUserId() async {}
  Future<void> fetchPrescriptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final uri =
        Uri.parse("http://10.0.2.2:8000/api/patient/getByUserId/$userId");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        _patientId = data['data']['Patient_ID'].toString();
      });
      setState(() {
        myPrescriptions = [];
      });
      final res = await http.get(Uri.parse(
          "http://10.0.2.2:8000/api/prescriptions/patient/${data['data']['Patient_ID'].toString()}"));
      final prescriptionData = jsonDecode(res.body);

      if (prescriptionData['status'] == "success") {
        List<dynamic> presList = prescriptionData['data'];

        // Iterate through each prescription
        for (var prescription in presList) {
          final medicineResponse = await http.get(Uri.parse(
              "http://10.0.2.2:8000/api/medicines/prescription/${prescription['Prescription_ID']}"));
          final medicineData = jsonDecode(medicineResponse.body);

          if (medicineData['status'] == "success") {
            // Extract medicines in the required format
            List<Map<String, String>> prescriptions =
                medicineData['data'].map<Map<String, String>>((medicine) {
              final name = medicine['Medicine'];
              final strength = medicine['Strength'];
              final quantity = medicine['Quantity'];
              return {
                "id": medicine['Medicine_ID'].toString(),
                "text": "$name $strength - $quantity"
              };
            }).toList();


            final keywordResponse = await http.get(Uri.parse(
                "http://10.0.2.2:8000/api/keywords/prescription/${prescription['Prescription_ID']}"));
            final keywordData = jsonDecode(keywordResponse.body);

            if (keywordData['status'] == "success") {
              String dateString = prescription['Date'].toString();
              DateTime parsedDate = DateTime.parse(dateString);
              String stringDate =
                  "${parsedDate.year}-${parsedDate.month}-${parsedDate.day}";

              if (prescription['IsHide'] == false) {
                setState(() {
                  myPrescriptions.add({
                    'id': prescription['Prescription_ID'],
                    'date': stringDate,
                    'doctor':
                        "Dr. ${prescription['Doctor_ID']['First_name']} ${prescription['Doctor_ID']['Last_name']} (${prescription['Doctor_ID']['Specialization']})",
                    'medications': prescriptions,
                    'progress': int.parse(prescription['Progress']
                        .toString()
                        .split('')[0]
                        .toString()),
                    'keywords': List<String>.from(
                        keywordData['data'].map((k) => k['Keyword'])),
                  });
                });
              }
            }
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: myPrescriptions.length,
    //   itemBuilder: (context, index) {
    //     final prescription = myPrescriptions[index];
    //     return PrescriptionCard(prescription: prescription);
    //   },
    // );
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchPrescriptions,
                child: ListView.builder(
                  itemCount: myPrescriptions.length,
                  itemBuilder: (context, index) {
                    final prescription = myPrescriptions[index];
                    return PrescriptionCard(prescription: prescription);
                  },
                )));
  }
}
