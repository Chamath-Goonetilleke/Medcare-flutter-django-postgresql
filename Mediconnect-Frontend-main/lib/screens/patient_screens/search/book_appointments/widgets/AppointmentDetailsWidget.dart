import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mediconnect/repository/appointment_queue_repository.dart';
import 'package:mediconnect/repository/appointment_repository.dart';
import 'package:mediconnect/repository/notification_repository.dart';
import 'package:mediconnect/screens/patient_screens/home/home_page/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentDetailsWidget extends StatefulWidget {
  final String doctorName;
  final int? selectedNumber;
  final ValueChanged<int?> onSelectNumber;
  final ValueChanged<String> onConsultationTypeChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onPlaceAppointment;
  final String hospital;
  final Map<String, dynamic> searchData;

  const AppointmentDetailsWidget({
    super.key,
    required this.doctorName,
    required this.selectedNumber,
    required this.onSelectNumber,
    required this.onConsultationTypeChanged,
    required this.onNoteChanged,
    required this.onPlaceAppointment,
    required this.hospital,
    required this.searchData,
  });

  @override
  State<AppointmentDetailsWidget> createState() =>
      _AppointmentDetailsWidgetState();
}

class _AppointmentDetailsWidgetState extends State<AppointmentDetailsWidget> {
  Map<String, dynamic>? visitData;
  final AppointmentRepository appointmentRepository = AppointmentRepository();
  final AppointmentQueueRepository queueRepository =
      AppointmentQueueRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  int token_no = 1;
  bool isLoading = true;

  String? _patientId;
  bool isQueueAvailable = false;
  int? queueId;
  String? appTime;

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString.split('.').first);

    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void getUserId() async {
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
      print(" pid: ${data['data']['Patient_ID'].toString()}");
    }
  }

  void fetchDoctorVisit() async {
    print("${widget.searchData['DoctorId']}");
    final uri = Uri.parse(
        "http://10.0.2.2:8000/api/visit/${widget.searchData['DoctorId']}/${widget.searchData['HospitalId']}");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        visitData = data['data'];
      });
      getQueue(data['data']['AP_Count'], data['data']['AP_Start_Time'],
          data['data']['AP_End_Time']);
    } else {
      throw Exception('Failed to load search results');
    }
  }

  void getQueue(int patientCount, String startTime, String endTime) async {
    final uri = Uri.parse(
        "http://10.0.2.2:8000/api/appointment-queues/getUniqueQueue/");
    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Doctor_ID": widget.searchData['DoctorId'],
          "Hospital_ID": widget.searchData['HospitalId'],
          "Date": formatDate(widget.searchData['Date'].toString()),
        }));
    final data = jsonDecode(response.body);

    if (data['status'] == "success") {
      setState(() {
        isQueueAvailable = true;
        queueId = data['data']['Queue_ID'];
      });

      final res = await http.get(Uri.parse(
          "http://10.0.2.2:8000/api/appointments/getByQueue/${data['data']['Queue_ID']}"));
      final queueData = jsonDecode(res.body);

      if (queueData['status'] == "success") {
        setState(() {
          token_no = int.parse(queueData['queue_length'].toString()) + 1;
        });

        // Parse startTime and endTime strings
        final DateFormat timeFormat = DateFormat("hh:mm a");
        final DateTime startDateTime = timeFormat.parse(startTime);
        final DateTime endDateTime = timeFormat.parse(endTime);

        // Calculate duration and slot duration per patient
        final Duration totalDuration = endDateTime.difference(startDateTime);
        final Duration slotDuration = totalDuration ~/ patientCount;

        // Calculate appointment time based on token_no
        final DateTime appointmentTime =
            startDateTime.add(slotDuration * (token_no - 1));
        final String formattedAppointmentTime =
            timeFormat.format(appointmentTime);

        setState(() {
          appTime = formattedAppointmentTime;
          isLoading = false;
        });
      } else {
        setState(() {
          appTime = startTime;
          isLoading = false;
        });
      }
    } else {
     setState(() {
        appTime = startTime;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDoctorVisit();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an Appointment with ${widget.doctorName}'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor name: Dr. ${widget.doctorName}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Medical Center: ${widget.hospital}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      TextButton(
                        onPressed: () {
                          // Handle See Location press
                        },
                        child: const Text(
                          'See Location',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${formatDate(widget.searchData['Date'].toString())}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Token No : $token_no',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Approx. time',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appTime != null ? appTime! : "11.00AM",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This time may vary. So make sure to visit the medical center/hospital on time',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            widget.onConsultationTypeChanged('In-person'),
                        child: const Text('In-person'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 116, 198, 236),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            widget.onConsultationTypeChanged('Online'),
                        child: const Text('Online'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'My note',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'John Doe - Chest Pain',
                      ),
                      onChanged: widget.onNoteChanged,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isQueueAvailable) {
                          var response =
                              await appointmentRepository.createAppointment(
                                  appointment: jsonEncode({
                            "Patient_ID": _patientId,
                            "Doctor_ID": widget.searchData['DoctorId'],
                            "Start_time":
                                visitData!['AP_Start_Time'].toString(),
                            "End_time": visitData!['AP_End_Time'].toString(),
                            "Date": formatDate(
                                widget.searchData['Date'].toString()),
                            "Hospital_ID": widget.searchData['HospitalId'],
                            "Disease": widget.searchData['Disease'],
                            "Token_no": token_no,
                            "Approx_Time": appTime,
                            "Queue_ID": queueId,
                          }));
                          if (response['status'] == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Appointment Placed successfully')),
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error Making Appointment')),
                            );
                          }
                        } else {
                          final res =
                              await queueRepository.createAppointmentQueue(
                                  appointmentQueue: jsonEncode({
                            "Doctor_ID": widget.searchData['DoctorId'],
                            "Hospital_ID": widget.searchData['HospitalId'],
                            "Date": formatDate(
                                widget.searchData['Date'].toString()),
                          }));
                          if (res['status'] == "success") {
                            var response =
                                await appointmentRepository.createAppointment(
                                    appointment: jsonEncode({
                              "Patient_ID": _patientId,
                              "Doctor_ID": widget.searchData['DoctorId'],
                              "Start_time":
                                  visitData!['AP_Start_Time'].toString(),
                              "End_time": visitData!['AP_End_Time'].toString(),
                              "Date": formatDate(
                                  widget.searchData['Date'].toString()),
                              "Hospital_ID": widget.searchData['HospitalId'],
                              "Disease": widget.searchData['Disease'],
                              "Token_no": token_no,
                              "Approx_Time": appTime,
                              "Queue_ID": res['data']['Queue_ID'],
                            }));
                            if (response['status'] == "success") {
                              final notiResponse = await _notificationRepository
                                  .createNotification(
                                      notification: jsonEncode({
                                "Doctor_ID": widget.searchData['DoctorId'],
                                "Date": DateTime.now().toString(),
                                "Note":
                                    "You  have an appointment on ${formatDate(widget.searchData['Date'].toString())} at ${widget.hospital}"
                              }));
                              if(notiResponse['status'] == "success"){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Appointment Placed successfully')),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              }
                              
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error Making Appointment')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error Making Appointment')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Place Appointment',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
