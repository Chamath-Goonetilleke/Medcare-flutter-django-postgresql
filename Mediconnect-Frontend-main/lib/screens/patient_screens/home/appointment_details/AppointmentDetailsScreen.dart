import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/repository/appointment_repository.dart';
import 'package:mediconnect/screens/patient_screens/home/home_page/HomePage.dart';

import '../../../../themes/appointmentStatusColors.dart';
import '../rate/RateScreen.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentName;
  final String doctorName;
  final String specialty;
  final String appointmentTime;
  final String appointmentDate;
  final String location;
  final int appointmentNumber;
  final int currentNumber;
  final String turnTime;
  final String appointmentStatus;
  final Map<String, dynamic> appointment;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointmentName,
    required this.doctorName,
    required this.specialty,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.location,
    required this.appointmentNumber,
    required this.currentNumber,
    required this.turnTime,
    required this.appointmentStatus, required this.appointment,
  });

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString.split('.').first);

    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person, size: 40),
              title: Text(
                "${widget.doctorName} - ${widget.appointmentName}",
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${widget.doctorName}(${widget.specialty})"),
            ),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.calendar_today, size: 40),
              title: Text(
                formatDate(widget.appointmentDate),
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(widget.appointmentTime),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, size: 40),
              title: Text(widget.location),
            ),
            const SizedBox(height: 20),
            Text(
              "My number: ${widget.appointmentNumber}",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Current attending number: ${widget.currentNumber}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "My turn at (approx.): ${widget.turnTime}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              color: getAppointmentStatusColor(
                  widget.appointmentStatus), // Use the status color method
              child: Center(
                child: Text(
                  "Appointment Status: ${widget.appointmentStatus}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.appointment['Is_Rate'] ?  const SizedBox(): ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RateScreen(
                                doctorName: 'Dr. John Doe',
                                appointment: widget.appointment,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        child: const Text(
                          "Rate",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                ElevatedButton(
                  onPressed: ()async{
                   final response = await _appointmentRepository
                        .deleteAppointment(apId: widget.appointment['Appointment_ID']);
                    if (response['status'] == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Appointment Deleted Successfully '),
                      ));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Appointment Deleting Fail '),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                  ),
                  child: const Text(
                    "Remove Appointment",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}