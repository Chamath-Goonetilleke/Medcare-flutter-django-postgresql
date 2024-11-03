import 'package:mediconnect/screens/doctor_screens/NextPatientpage/procedtoprescription.dart';
import 'package:mediconnect/screens/doctor_screens/PrescriptionsReport/Prescription.dart';
import 'package:mediconnect/screens/doctor_screens/homepage/line.dart';

import 'call.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NextPatient extends StatefulWidget {
  final int queueId;
  const NextPatient({super.key, required this.queueId});

  @override
  State<NextPatient> createState() => _NextPatientState();
}

class _NextPatientState extends State<NextPatient> {
  int? patientId;
  bool isPatientCalled = false;
  bool isLoading = true;
  Map<String, dynamic>? presDetails;
  Map<String, dynamic>? patientData;

  int calculateAge(String birthdate) {
    List<String> dateParts = birthdate.split('/');
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    DateTime birthDate = DateTime(year, month, day);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    if (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)) {
      age--;
    }

    return age;
  }

  Future<void> getQueue() async {
    final res = await http.get(Uri.parse(
        "http://10.0.2.2:8000/api/appointments/getFilteredQueue/${widget.queueId}"));
    final queueData = jsonDecode(res.body);

    if (queueData['status'] == "success") {
      setState(() {
        isLoading = false;
        if (queueData['data'].length > 0) {
          presDetails = {
            "docId": queueData['data'][0]['Doctor_ID']['Doctor_ID'],
            "patientId": queueData['data'][0]['Patient_ID']['Patient_ID'],
            "appointmentId": queueData['data'][0]['Appointment_ID'],
          };
          patientData = {
            "name":
                "${queueData['data'][0]['Patient_ID']['First_name']} ${queueData['data'][0]['Patient_ID']['Last_name']}",
            "age": calculateAge(queueData['data'][0]['Patient_ID']['Birthday'])
                .toString(),
            "disease": queueData['data'][0]['Disease'],
            "condition": queueData['data'][0]['Disease'],
            "imageUrl": "",
          };
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Failed to load patient data");
    }
  }

  @override
  void initState() {
    super.initState();
    getQueue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : patientData != null
              ? Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Next Patient",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            child: Image.network(
                              patientData!['imageUrl'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 120,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${patientData!['name']}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Age: ${patientData!['age']} yrs',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Disease: ${patientData!['disease']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'prior/present condition: ${patientData!['condition']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      !isPatientCalled
                          ? Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isPatientCalled = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 74, 224, 79),
                                ),
                                child: const Text(
                                  "Call",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            )
                          : Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  print(presDetails);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PrescriptionsReportsScreen(
                                              presDetails: presDetails!,
                                            )),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 3, 139, 251),
                                ),
                                child: const Text(
                                  "Proceed to Prescriptions/report",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              : const Column(
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        "No Patient Available",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
    );
  }
}
