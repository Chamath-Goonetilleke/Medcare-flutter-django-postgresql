import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HospitalDropdown extends StatefulWidget {
  final String? selectedHospital;
  final Function(String?) onHospitalChanged;

  const HospitalDropdown({
    required this.selectedHospital,
    required this.onHospitalChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<HospitalDropdown> createState() => HospitalDropdownState();
}

class HospitalDropdownState extends State<HospitalDropdown> {
  final List<String> hospitals = [
    'Cardiologist',
    'Orthopedic Surgeon',
    'General Practitioner',
    'Dermatologist',
    'Neurologist',
    'Other'
  ];

  Future<List<Map<String, dynamic>>> fetchMedicalCenters() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/hospitals/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((center) {
        return {
          'Hospital_ID': center['Hospital_ID'].toString(),
          'Hospital_Name': center['Name'] + ' - ' + center['Location']
        };
      }).toList();
    } else {
      throw Exception('Failed to load medical centers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMedicalCenters(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No medical centers available');
          } else {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Hospital',
                  ),
                  items: snapshot.data!.map((center) {
                    return DropdownMenuItem<String>(
                      value: center['Hospital_ID'],
                      child: Flexible(
                        child: Text(
                          center['Hospital_Name']!,
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: widget.onHospitalChanged,
                  value: widget.selectedHospital,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
