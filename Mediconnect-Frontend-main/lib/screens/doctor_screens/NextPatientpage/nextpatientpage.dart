import 'package:mediconnect/screens/doctor_screens/NextPatientpage/procedtoprescription.dart';
import 'package:mediconnect/screens/doctor_screens/PrescriptionsReport/Prescription.dart';
import 'package:mediconnect/screens/doctor_screens/homepage/line.dart';

import 'call.dart';
// import 'package:doctor/NextPatientpage/procedtoprescription.dart';
// import 'package:doctor/homepage/line.dart';
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

  int calculateAge(String birthdate) {
    // Split the input date to get month, day, and year
    List<String> dateParts = birthdate.split('/');
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Create a DateTime object from the parsed parts
    DateTime birthDate = DateTime(year, month, day);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    // Adjust age if the birthday hasn't occurred yet this year
    if (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)) {
      age--;
    }

    return age;
  }

  Future<Map<String, dynamic>> getQueue() async {
    final res = await http.get(Uri.parse(
        "http://10.0.2.2:8000/api/appointments/getByQueue/${widget.queueId}"));
    final queueData = jsonDecode(res.body);

    if (queueData['status'] == "success") {
      //   print(queueData['data'][0]);
      // setState(() {
      //   Id = queueData['data'][0];
      // });
      return {
        "name":
            "${queueData['data'][0]['Patient_ID']['First_name']} ${queueData['data'][0]['Patient_ID']['Last_name']}",
        "age": calculateAge(queueData['data'][0]['Patient_ID']['Birthday'])
            .toString(),
        "disease": queueData['data'][0]['Disease'],
        "condition": queueData['data'][0]['Disease'],
        "imageUrl": "",
      };
    } else {
      throw Exception("");
    }
  }

  Future<Map<String, dynamic>> fetchPatientData() async {
    final response = await http.get(
      Uri.parse('https://api.example.com/patient_data'), // sample URL
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        "name": data['name'],
        "age": data['age'],
        "disease": data['disease'],
        "condition": data['condition'],
        "imageUrl": data['imageUrl'],
      };
    } else {
      // Handle errors with fallback data
      throw Exception('Failed to load patient data');
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: getQueue(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Next Patient",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Next Patient",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                          child: Text("Page loading Error",
                              style: TextStyle(fontSize: 16))),
                    ]));
          } else if (snapshot.hasData) {
            final patientData = snapshot.data!;
            final name = patientData['name'];
            final age = patientData['age'];
            final disease = patientData['disease'];
            final condition = patientData['condition'];
            final imageUrl = patientData['imageUrl'];

            return Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Next Patient",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: Image.network(
                          imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Show a default icon if image fails to load
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
                              'Name: $name',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Age: $age yrs',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Disease: $disease',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'prior/present condition: $condition',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  !isPatientCalled
                      ? Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // // Add your onPressed logic here
                              // if (kDebugMode) {
                              //   print('Call button pressed!');
                              // }
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PrescriptionsReportsScreen()),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.only(left: 0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Next Patient",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Center(child: Text("No Patients")),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
