import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:mediconnect/screens/doctor_screens/PrescriptionsReport/AddNewPrecription.dart';

class PrescriptionsReportsScreen extends StatefulWidget {
  const PrescriptionsReportsScreen({Key? key}) : super(key: key);

  @override
  _PrescriptionsReportsScreenState createState() =>
      _PrescriptionsReportsScreenState();
}

class _PrescriptionsReportsScreenState
    extends State<PrescriptionsReportsScreen> {
  bool prescribedByMe = false;
  String keyword = '';
  DateTime? selectedDate;
  final currentLoggedDoctorID = 1;

  final List<Map<String, dynamic>> reports = [
    {
      'doctorID': 1,
      'date': DateTime(2024, 2, 15),
      'doctorName': "Dr. John Doe (Cardiac Surgeon)",
      'prescriptions': [
        "Panadine 20mg - 10 tablets",
        "Digene 5mg - 5 tablets",
        "Pantodac 10mg - 10 tablets"
      ],
      'progress': "60%",
      'keywords': ["Gastritis"],
    },
    {
      'doctorID': 2,
      'date': DateTime(2024, 3, 20),
      'doctorName': "Dr. Jane Smith (Pediatrician)",
      'prescriptions': [
        "Amoxicillin 500mg - 7 capsules",
        "Paracetamol 10mg - 5 tablets"
      ],
      'progress': "80%",
      'keywords': ["Cold", "Fever"],
    },
  ];

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
      body: SingleChildScrollView(
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
                      : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 20),

              // Display Reports in ListView
              filteredReports.isEmpty
                  ? const Text("No reports found matching the criteria.")
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPrescriptionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    "Add new",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Report Card Widget
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
