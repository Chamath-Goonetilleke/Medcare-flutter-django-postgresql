import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mediconnect/screens/patient_screens/search/search_page/widgets/widgets.dart';
import 'package:mediconnect/screens/patient_screens/search/search_results/SearchResults.dart';
import 'package:mediconnect/widgets/bottom_nav_bar/PatientBottomNavBar.dart';

class SearchPagescaffold extends StatefulWidget {
  const SearchPagescaffold({super.key});

  @override
  _SearchPageScaffoldState createState() => _SearchPageScaffoldState();
}

class _SearchPageScaffoldState extends State<SearchPagescaffold> {
  String? selectedDoctorId = null;
  String? selectedMedicalCenterId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? disease;
  List<dynamic> doctorVisits = [];
  String? selectedHospitalName;
  bool isSearchEnabled = false;

  Map<String, dynamic> searchData = {};
  List<dynamic> hospitals = [];
  Map<String, dynamic>? visitData;

  final TextEditingController diseaseController = TextEditingController();

  void setSearchData() {
    searchData = {
      'DoctorId': selectedDoctorId,
      'HospitalId': selectedMedicalCenterId,
      'Date': selectedDate,
      'Time': selectedTime,
      'Disease': disease,
    };
  }

  Future<List<Map<String, dynamic>>> _fetchDoctors() async {
    final response =
        await http.get(Uri.parse('http://13.49.21.193:8000/api/doctors'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      doctorVisits = data['data'] as List;
      return (data['data'] as List).map((doctor) {
        return {
          'Doctor_ID': doctor['Doctor_ID'].toString(),
          'Doctor_Name':
              'Dr. ' + doctor['First_name'] + ' ' + doctor['Last_name']
        };
      }).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<Map<String, dynamic>> fetchDoctorVisit() async {
    final uri = Uri.parse(
        "http://13.49.21.193:8000/api/visit/${selectedDoctorId}/${selectedMedicalCenterId}");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        visitData = data['data'];
      });
      return data['data'];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMedicalCenters() async {
    final response =
        await http.get(Uri.parse('http://13.49.21.193:8000/api/hospitals/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      hospitals = data['data'];
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

  Future<List<Map<String, dynamic>>> _fetchDoctorVisits() async {
    final response = await http.get(Uri.parse(
        'http://13.49.21.193:8000/api/visit/doctor/$selectedDoctorId/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      hospitals = data['data'];
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _validateDoctorAvailability();
    }
  }

  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final Map<String, bool> daySelected = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };

  void _validateDoctorAvailability() {
    if (visitData != null && selectedDate != null) {
      String selectedDay = DateFormat('EEE').format(selectedDate!);
      print(selectedDay);
      if (visitData![selectedDay] == true) {
        isSearchEnabled = true;
      } else {
        setState(() {
          selectedDate = null;
          isSearchEnabled = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doctor is not available on $selectedDay')),
        );
      }
    }
  }

  void _searchDoctors() {
    setSearchData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          doctorName: selectedDoctorId,
          disease: disease,
          searchData: searchData,
          medicalCenter: selectedHospitalName,
          date: selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
              : null,
          time: selectedTime?.format(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search for a Doctor"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchDoctors(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No doctors available');
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Search by Doctor Name',
                        ),
                        items: snapshot.data!.map((doctor) {
                          return DropdownMenuItem<String>(
                            value: doctor['Doctor_ID'],
                            child: Text(doctor['Doctor_Name']!),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedDoctorId = value;
                          });
                        },
                        value: selectedDoctorId,
                      ),
                    );
                  }
                },
              ),
              selectedDoctorId == null
                  ? FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchMedicalCenters(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No medical centers available');
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Search by Medical Center',
                              ),
                              items: snapshot.data!.map((center) {
                                return DropdownMenuItem<String>(
                                  value: center['Hospital_Name'],
                                  child: Text(center['Hospital_Name']!),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedMedicalCenterId = value;
                                });
                                fetchDoctorVisit();
                              },
                              value: selectedMedicalCenterId,
                            ),
                          );
                        }
                      },
                    )
                  : FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchDoctorVisits(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No medical centers available');
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Search by Medical Center',
                              ),
                              items: snapshot.data!.map((center) {
                                return DropdownMenuItem<String>(
                                  value: center['Hospital_ID'],
                                  child: Text(center['Hospital_Name']!),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                String? name;
                                for (var hospital in hospitals) {
                                  if (hospital['Hospital_ID'].toString() ==
                                      value.toString()) {
                                    name =
                                        "${hospital['Name']} - ${hospital['Location']} ";
                                  }
                                }
                                setState(() {
                                  selectedMedicalCenterId = value;
                                  selectedHospitalName = name;
                                });
                                fetchDoctorVisit();
                              },
                              value: selectedMedicalCenterId,
                            ),
                          );
                        }
                      },
                    ),
              visitData != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Doctor Visiting Days",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              children: daysOfWeek.map((day) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: visitData![day],
                                      onChanged: (bool? value) {},
                                    ),
                                    Text(day),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Appointment Visits",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Time : ${visitData!['AP_Start_Time']} - ${visitData!['AP_End_Time']}",
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Appointment Less Visits",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Time : ${visitData!['APL_Start_Time']} - ${visitData!['APL_End_Time']}",
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )
                  : const Row(),
              const SizedBox(height: 10),
              TextField(
                controller: diseaseController,
                decoration: const InputDecoration(
                  labelText: 'Search by Disease',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    disease = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DatePickerField(
                selectedDate: selectedDate,
                onDateSelected: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSearchEnabled ? _searchDoctors : null,
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}
