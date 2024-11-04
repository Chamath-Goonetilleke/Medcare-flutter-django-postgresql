import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/repository/doctor_repository.dart';
import 'package:mediconnect/screens/doctor_screens/NextPatientpage/nextpatientpage.dart';
import 'package:mediconnect/screens/doctor_screens/homepage/addtodaysplanbutton.dart';
import 'package:mediconnect/screens/doctor_screens/homepage/nextpatent.dart';
import 'package:mediconnect/screens/doctor_screens/homepage/todaytaskcontainer.dart';
import 'elevatedbutton.dart';
import 'viewdrop.dart';
import 'confrimbutton.dart';
import 'available.dart';
import 'line.dart';
import 'numofpatient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String _currentLocation = "maharagama";
// This widget displays the number of patients.
  Widget numofpatient(int? queueLength) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Patients in queue: ${queueLength ?? 0}',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  DoctorRepository doctorRepository = DoctorRepository();

  Map<String, dynamic>? doctor;
  List<dynamic> hospitals = [];
  String? selectedMedicalCenterId;
  String? selectedHospitalName;
  bool isHospitalsFetched = false;

  bool isQueueAvailable = false;
  int? queueId;
  int? queueLength = 0;

  @override
  void initState() {
    super.initState();
    getDoctorDetails();
  }

  Future<void> getDoctorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final uri =
        Uri.parse("http://10.0.2.2:8000/api/doctors/getByUserId/$userId");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        doctor = data['data'];
        if (data['data']['Current_HOS_ID'] != null) {
          selectedMedicalCenterId =
              data['data']['Current_HOS_ID']['Hospital_ID'].toString();
        }
      });
      await fetchHospitalsAndQueue();
    }
  }

  Future<void> fetchHospitalsAndQueue() async {
    // Fetch hospitals only once
    if (!isHospitalsFetched && doctor != null) {
      final res = await http.get(Uri.parse(
          'http://10.0.2.2:8000/api/visit/doctor/${doctor!['Doctor_ID']}/'));
      if (res.statusCode == 200) {
        final hosData = jsonDecode(res.body);
        hospitals = hosData['data'];
        isHospitalsFetched = true;
        await getQueue(); // Fetch queue after getting hospitals
      } else {
        throw Exception('Failed to load medical centers');
      }
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString.split('.').first);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<void> getQueue() async {
    final uri = Uri.parse(
        "http://10.0.2.2:8000/api/appointment-queues/getUniqueQueue/");
    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Doctor_ID": doctor!['Doctor_ID'],
          "Hospital_ID": selectedMedicalCenterId,
          "Date": '2024-11-04'
        }));
    final data = jsonDecode(response.body);

    if (data['status'] == "success") {
      setState(() {
        isQueueAvailable = true;
        queueId = data['data']['Queue_ID'];
      });
      final res = await http.get(Uri.parse(
          "http://10.0.2.2:8000/api/appointments/getFilteredQueue/${data['data']['Queue_ID']}"));
      final queueData = jsonDecode(res.body);

      if (queueData['status'] == "success") {
        setState(() {
          queueLength = int.parse(queueData['queue_length'].toString());
        });
      }
    } else {
      setState(() {
        isQueueAvailable = false;
        queueLength = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 0, left: 16.0, right: 18.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hello\nDr. ${doctor?['First_name'] ?? ''} ${doctor?['Last_name'] ?? ''}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 30, height: 1),
              ),
            ),
            Row(
              children: [
                elevationbutton("Overview"),
                const SizedBox(width: 6.0),
                elevationbutton("Productivity"),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "I'm now in ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: FutureBuilder<void>(
                            future: fetchHospitalsAndQueue(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Getting Current Hospital...");
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                  items: hospitals.map((center) {
                                    return DropdownMenuItem<String>(
                                      value: center['Hospital_ID'].toString(),
                                      child: Text(
                                          '${center['Name']} - ${center['Location']}', style: TextStyle(fontSize: 13),),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) async {
                                    String? name;
                                    for (var hospital in hospitals) {
                                      if (hospital['Hospital_ID'].toString() ==
                                          value) {
                                        name =
                                            "${hospital['Name']} - ${hospital['Location']}";
                                      }
                                    }
                                    setState(() {
                                      selectedMedicalCenterId = value;
                                      selectedHospitalName = name;
                                    });

                                    final res =
                                        await doctorRepository.updateDoctor(
                                            currentHos: int.parse(value!),
                                            docId: doctor!['Doctor_ID']);
                                    if (res['status'] == "success") {
                                      await getQueue();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Current Hospital Changed')),
                                      );
                                    }
                                  },
                                  value: selectedMedicalCenterId,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 150),
                        confrim(_currentLocation),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            available(),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NextPatient(queueId: queueId!)),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.lightBlue.shade100,
              ),
              child: const Text(
                "Next Patient",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              child: numofpatient(queueLength),
            ),
            const SizedBox(height: 0),
            line(Colors.black, 400.0, 8.0),
            const SizedBox(
              height: 5,
            ),
            const Align(
              alignment: Alignment.centerLeft, // Aligns to the left
              child: Text(
                "Today's Plan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const TodayTaskContainer(confirmButtonStatus: false),
            const AddTodaysTask(),
          ],
        ),
     
      ),
    );
  }
}
