import 'package:flutter/material.dart';
import '../widgets/widgets.dart'; // Import all widgets from the widgets.dart file
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mediconnect/widgets/bottom_nav_bar/PatientBottomNavBar.dart';
import 'package:mediconnect/screens/common_screens/switch_user/switchUser.dart';
import 'package:mediconnect/screens/patient_screens/home/appointment_details/AppointmentDetailsScreen.dart';
import 'package:mediconnect/themes/AppointmentStatusColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageScaffold extends StatefulWidget {
  const HomePageScaffold({super.key});

  @override
  _HomePageScaffoldState createState() => _HomePageScaffoldState();
}

class _HomePageScaffoldState extends State<HomePageScaffold> {
  final String userEmail = "johndoe@example.com";
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/appointments/'));
        print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final data = jsonDecode(response.body);
      appointments = data['data'] as List;
      print("${appointments[0]['Disease']}");
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            onPressed: () {
              switchUser(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: QrImageView(
                      data: userEmail,
                      size: 200.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'My Appointments',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return AppointmentButton(
                          color: appointment['Status'] == "Queued" ? Colors.yellow : Colors.red,
                          text:
                              "${appointment['Disease']} - Dr.${appointment['Doctor_ID']['First_name']}",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentDetailsScreen(
                                  appointmentName:
                                      "${appointment['Disease']} - Dr.${appointment['Doctor_ID']['First_name']} ${appointment['Doctor_ID']['Last_name']}",
                                  doctorName: appointment['Doctor_ID']['First_name'],
                                  specialty: appointment['Doctor_ID']
                                      ['Specialization'],
                                  appointmentTime:
                                      appointment['Start_time'],
                                  appointmentDate:
                                      appointment['Date'],
                                  location: appointment['Hospital_ID']['Name'],
                                  appointmentNumber:
                                      appointment['Token_no'],
                                  currentNumber: appointment['Token_no'],
                                  turnTime: appointment['Start_time'],
                                  appointmentStatus:
                                      appointment['Status'],
                                ),
                              ),
                            );
                          
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }
}
