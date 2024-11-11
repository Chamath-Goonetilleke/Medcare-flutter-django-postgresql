import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:mediconnect/repository/appointment_repository.dart';
import 'package:mediconnect/screens/doctor_screens/PrescriptionsReport/AddNewPrecription.dart';
import 'package:http/http.dart' as http;
import 'package:mediconnect/screens/doctor_screens/doctormain.dart';

class PrescriptionsReportsScreen extends StatefulWidget {
  final Map<String, dynamic> presDetails;
  const PrescriptionsReportsScreen({Key? key, required this.presDetails})
      : super(key: key);

  @override
  _PrescriptionsReportsScreenState createState() =>
      _PrescriptionsReportsScreenState();
}

class _PrescriptionsReportsScreenState
    extends State<PrescriptionsReportsScreen> {
  bool prescribedByMe = false;
  String keyword = '';
  DateTime? selectedDate;
  int? currentLoggedDoctorID;
  bool isLoading = true;
  final AppointmentRepository _appointmentRepository = AppointmentRepository();
  List<Map<String, dynamic>> reports = [];

  List<Map<String, dynamic>> get filteredReports {
    return reports.where((report) {
      if (prescribedByMe && report['doctorID'] != currentLoggedDoctorID) {
        return false;
      }
      if (keyword.isNotEmpty &&
          !report['keywords'].any((dynamic k) =>
              (k as String).toLowerCase().contains(keyword.toLowerCase()))) {
        return false;
      }
      if (selectedDate != null && report['date'] != selectedDate) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> fetchPrescriptions() async {
    setState(() {
      reports = [];
    });
    final res = await http.get(Uri.parse(
        "http://13.60.21.117:8000/api/prescriptions/patient/${widget.presDetails['patientId']}"));
    final prescriptionData = jsonDecode(res.body);

    if (prescriptionData['status'] == "success") {
      List<dynamic> presList = prescriptionData['data'];

      // Iterate through each prescription
      for (var prescription in presList) {
        final medicineResponse = await http.get(Uri.parse(
            "http://13.60.21.117:8000/api/medicines/prescription/${prescription['Prescription_ID']}"));
        final medicineData = jsonDecode(medicineResponse.body);

        if (medicineData['status'] == "success") {
          // Extract medicines in the required format
          List<String> prescriptions =
              medicineData['data'].map<String>((medicine) {
            final name = medicine['Medicine'];
            final strength = medicine['Strength'];
            final quantity = medicine['Quantity'];
            return "$name $strength - $quantity";
          }).toList();

          final keywordResponse = await http.get(Uri.parse(
              "http://13.60.21.117:8000/api/keywords/prescription/${prescription['Prescription_ID']}"));
          final keywordData = jsonDecode(keywordResponse.body);

          if (keywordData['status'] == "success") {
            String dateString = prescription['Date'].toString();
            DateTime parsedDate = DateTime.parse(dateString);
            DateTime dateOnly =
                DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

            if (prescription['IsHide'] == false) {
              setState(() {
                reports.add({
                  'doctorID': prescription['Doctor_ID']['Doctor_ID'],
                  'date': dateOnly,
                  'doctorName':
                      "Dr. ${prescription['Doctor_ID']['First_name']} ${prescription['Doctor_ID']['Last_name']} (${prescription['Doctor_ID']['Specialization']})",
                  'prescriptions': prescriptions,
                  'progress': prescription['Progress'],
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

  @override
  void initState() {
    super.initState();
    fetchPrescriptions();
    currentLoggedDoctorID = int.parse(widget.presDetails['docId'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Prescriptions/Reports'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchPrescriptions,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Prescribed by me" Checkbox
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Prescribed by me',
                              style: TextStyle(fontSize: 16),
                            ),
                            Checkbox(
                              value: prescribedByMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  prescribedByMe = value!;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Filter by Keyword
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              keyword = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Filter by keyword...',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.filter_alt_outlined),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Filter by Date with Date Picker
                        TextFormField(
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelText: selectedDate == null
                                ? 'Filter by date...'
                                : DateFormat('yyyy-MM-dd')
                                    .format(selectedDate!),
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPrescriptionScreen(
                                          presDetails: widget.presDetails,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text(
                              "+ Add new",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Display Reports in ListView
                        filteredReports.isEmpty
                            ? const Text(
                                "No reports found matching the criteria.")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredReports.length,
                                itemBuilder: (context, index) {
                                  final report = filteredReports[index];
                                  return _buildReportCard(report);
                                },
                              ),

                        const SizedBox(height: 20),

                        // "Add new" Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              final appResponse = await _appointmentRepository
                                  .updateAppointment(
                                      appointment:
                                          jsonEncode({"Status": "Completed"}),
                                      apId:
                                          widget.presDetails['appointmentId']);

                              if (appResponse['status'] == "success") {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Appointment Completed')),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DoctorHomeScreen()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              "Complete Appointment",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM d, yyyy').format(report['date']),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(report['progress']),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Doctor's Name
            Text(
              report['doctorName'],
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
            const SizedBox(height: 10),

            // Prescription details
            Text(
              report['prescriptions'].join("\n"),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Keywords
            const Text(
              "Key Words:",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            Wrap(
              children: report['keywords']
                  .map<Widget>((keyword) => Chip(
                        label: Text(keyword),
                        backgroundColor: Colors.grey[300],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
