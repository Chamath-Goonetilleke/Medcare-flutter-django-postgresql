import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../themes/appointmentStatusColors.dart';
import '../rate/RateScreen.dart';

class AppointmentDetailsScreen extends StatelessWidget {
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
    required this.appointmentStatus,
  });

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString.split('.').first);

    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

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
                "$doctorName - $appointmentName",
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("$doctorName($specialty)"),
            ),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.calendar_today, size: 40),
              title: Text(
                formatDate(appointmentDate),
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(appointmentTime),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, size: 40),
              title: Text(location),
            ),
            const SizedBox(height: 20),
            Text(
              "My number: $appointmentNumber",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Current attending number: $currentNumber",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "My turn at (approx.): $turnTime",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              color: getAppointmentStatusColor(
                  appointmentStatus), // Use the status color method
              child: Center(
                child: Text(
                  "Appointment Status: $appointmentStatus",
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RateScreen(
                          doctorName: 'Dr. John Doe',
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
                  onPressed: () {
                    // Handle remove appointment action
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