import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? _patientId;

  

  Future<void> fetchData(String pid) async {
    final response =
        await http.get(Uri.parse('http://13.60.21.117:8000/api/appointments/getByPatient/$pid'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final data = jsonDecode(response.body);
      appointments = data['data'] as List;
      print("${appointments[0]['Disease']}");
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load doctors');
    }
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final uri =
        Uri.parse("http://13.60.21.117:8000/api/patient/getByUserId/$userId");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        _patientId = data['data']['Patient_ID'].toString();
      });
    fetchData(data['data']['Patient_ID'].toString());
      print(" pid: ${data['data']['Patient_ID'].toString()}");
    }
  }
@override
  void initState() {
    super.initState();
    getUserId();
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
                      data: _patientId.toString(),
                      size: 200.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'My Appointments',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  appointments.length > 0?
                  Expanded(
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return AppointmentButton(
                          color: appointment['Status'] == "Queued"
                              ? Colors.yellow
                              :appointment['Status'] == "Completed"
                              ? Colors.green: Colors.red,
                          text:
                              "${appointment['Disease']} - Dr.${appointment['Doctor_ID']['First_name']} ${appointment['Doctor_ID']['Last_name']}",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentDetailsScreen(
                                  appointmentName:
                                      "${appointment['Disease']}",
                                  doctorName: "Dr.${appointment['Doctor_ID']['First_name']} ${appointment['Doctor_ID']['Last_name']}",
                                  specialty: appointment['Doctor_ID']
                                      ['Specialization'],
                                  appointmentTime: "${appointment['Start_time'] } - ${appointment['End_time']}",
                                  appointmentDate: appointment['Date'],
                                  location: appointment['Hospital_ID']['Name'],
                                  appointmentNumber: appointment['Token_no'],
                                  currentNumber: appointment['Queue_ID']['Current_Number'],
                                  turnTime: appointment['Approx_Time'],
                                  appointmentStatus: appointment['Status'],
                                  appointment: appointment,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                : const Padding(
                  padding: EdgeInsets.fromLTRB(8, 40, 8, 8),
                  child: Center(child: Text("No Appointment Available"),),
                )
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
