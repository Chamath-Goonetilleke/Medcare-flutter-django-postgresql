import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediconnect/repository/appointment_repository.dart';
import 'package:mediconnect/repository/doctor_repository.dart';
import 'package:mediconnect/screens/patient_screens/home/home_page/HomePage.dart';

class RateScreen extends StatefulWidget {
  final String doctorName;
  final Map<String, dynamic> appointment;

  RateScreen({required this.doctorName, required this.appointment});

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int _doctorRating = 0; // Stores the selected rating for the doctor
  int _centerRating = 0; // Stores the selected rating for the medical center

  final AppointmentRepository _appointmentRepository = AppointmentRepository();
  final DoctorRepository _doctorRepository = DoctorRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rate Doctor Section
            const SizedBox(height: 5),
            Text(
              'Rate Doctor',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/Doctor.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. ${widget.appointment['Doctor_ID']['First_name']} ${widget.appointment['Doctor_ID']['Last_name']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                              "${widget.appointment['Doctor_ID']['Specialization']}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '$_doctorRating/5',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _doctorRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _doctorRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 10),

            // Rate Medical Center Section
            Text(
              'Rate Medical Center',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medical Center Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/MedicalCenter.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.appointment['Hospital_ID']['Name']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                              "${widget.appointment['Hospital_ID']['Location']}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '$_centerRating/5',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _centerRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _centerRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 0),

            // Comment Section
            TextField(
              decoration: InputDecoration(
                hintText: 'Comments about medical center...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.all(16.0),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 10),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  double rate =
                      widget.appointment['Doctor_ID']['Rating'] + _doctorRating;
                  int rateCount =
                      widget.appointment['Doctor_ID']['Rating_Count'] + 1;

                  final docResponse = await _doctorRepository.updateDoctorRate(
                      doctor: jsonEncode({
                        "Rating": rate / rateCount,
                        "Rating_Count": rateCount
                      }),
                      docId: widget.appointment['Doctor_ID']['Doctor_ID']);

                  if (docResponse['status'] == "success") {
                    final apResponse =
                        await _appointmentRepository.updateAppointment(
                            appointment: jsonEncode({"Is_Rate": true}),
                            apId: widget.appointment['Appointment_ID']);

                    if (apResponse['status'] == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Rating Submitted Success'),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error Submitting Rating'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error Submitting Rating'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 163, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        color: Colors.black, width: 2.0), // Black border
                  ),
                ),
                child: const Text(
                  'Submit',
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
