import 'package:flutter/material.dart';
import 'package:mediconnect/screens/doctor_screens/StatsPage/widgets/appointmenttable.dart';
import 'package:mediconnect/screens/doctor_screens/StatsPage/widgets/rating.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Barchart extends StatefulWidget {
  const Barchart({super.key});

  ///////////////////////////////////////////////////////  this part shows booked Appointment ////////////////////////////////////////////////////
  // ignore: non_constant_identifier_names
  static List<BarChartGroupData> createSampleAppointmentData() {
    final data = [
      Barmodel('Mon', 10),
      Barmodel('Tue', 40),
      Barmodel('Wed', 50),
      Barmodel('Thu', 100),
      Barmodel('Fri', 75),
      Barmodel('Sat', 65),
      Barmodel('Sun', 80),
    ];

    return data.asMap().entries.map((entry) {
      int index = entry.key;
      Barmodel barmodel = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: barmodel.count.toDouble(),
            color: Colors.green,
            width: 20,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    }).toList();
  }

  @override
  State<Barchart> createState() => _BarchartState();
}

class _BarchartState extends State<Barchart> {
  Map<String, dynamic>? doctor;
  bool isLoading = true;

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
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getDoctorDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "STATS",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        automaticallyImplyLeading: false,
      ),
      
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text("No of Patients Treat",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text("${doctor!['Patient_Count']}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                  const SizedBox(height: 40),
                  Center(
                      child: const Text("Rate",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                  Rating(doctor!['Rating']),
                ],
              ),
            ),
    );
  }
}

class Barmodel {
  final String year;
  final int count;
  Barmodel(this.year, this.count);
}

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Barchart(),
    );
  }
}
