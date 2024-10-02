import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediconnect/repository/hospital_repository.dart';
import 'package:mediconnect/screens/common_screens/register/doctor_registration/widgets/HospitalDropdown.dart';

class VisitingHospitalField extends StatefulWidget {
  @override
  State<VisitingHospitalField> createState() => _VisitingHospitalFieldState();
}

class _VisitingHospitalFieldState extends State<VisitingHospitalField> {
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController hospitalLocationController =
      TextEditingController();

  TimeOfDay? appointedStartTime;
  TimeOfDay? appointedEndTime;
  final TextEditingController appointedCountController =
      TextEditingController();

  TimeOfDay? appointlessStartTime;
  TimeOfDay? appointlessEndTime;
  final TextEditingController appointlessCountController =
      TextEditingController();
  final hospitalRepository = HospitalRepository();

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

  String? _selectedHospital;

  Future<void> _pickTime(
      BuildContext context, ValueChanged<TimeOfDay?> onTimePicked) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        onTimePicked(pickedTime);
      });
    }
  }

  Future<void> _openAddHospitalDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Hospital'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: hospitalNameController,
                decoration: const InputDecoration(labelText: 'Hospital Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: hospitalLocationController,
                decoration:
                    const InputDecoration(labelText: 'Hospital Location'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (hospitalNameController.text.isNotEmpty &&
                    hospitalLocationController.text.isNotEmpty) {
                  var response = await hospitalRepository.createHospital(
                      hospital: jsonEncode(<String, dynamic>{
                    "Location": hospitalLocationController.text,
                    "Rating": 0,
                    "Name": hospitalNameController.text
                  }));

                  if(response['status'] == "success") {
                  Navigator.of(context).pop();
                  }
                  if (response['status'] == "error") {
                    // _showErrorDialog(context, response['message']);
                    SnackBar(
                      content: Text(response['message'].toString()),
                    );
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: HospitalDropdown(
                    selectedHospital: _selectedHospital,
                    onHospitalChanged: (hospital) {
                      setState(() {
                        _selectedHospital = hospital;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _openAddHospitalDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: daysOfWeek.map((day) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: daySelected[day],
                    onChanged: (bool? value) {
                      setState(() {
                        daySelected[day] = value!;
                      });
                    },
                  ),
                  Text(day),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                const Row(children: [
                  Text("Appointed Patients"),
                ]),
                Row(
                  children: [
                    const Text("Start Time: "),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: TextButton(
                          onPressed: () => _pickTime(
                              context, (time) => appointedStartTime = time),
                          child: Text(
                            appointedStartTime != null
                                ? appointedStartTime!.format(context)
                                : 'Start Time',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("End Time: "),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: TextButton(
                          onPressed: () => _pickTime(
                              context, (time) => appointedEndTime = time),
                          child: Text(
                            appointedEndTime != null
                                ? appointedEndTime!.format(context)
                                : 'Select End Time',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Patient Count: "),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: TextFormField(
                          controller: appointedCountController,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // Appointless Patients Time Row
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                const Row(children: [
                  Text("Appointless Patients"),
                ]),
                Row(
                  children: [
                    const Text("Start Time: "),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: TextButton(
                          onPressed: () => _pickTime(
                              context, (time) => appointlessStartTime = time),
                          child: Text(
                            appointlessStartTime != null
                                ? appointlessStartTime!.format(context)
                                : 'Select Start Time',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("End Time: "),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: TextButton(
                          onPressed: () => _pickTime(
                              context, (time) => appointlessEndTime = time),
                          child: Text(
                            appointlessEndTime != null
                                ? appointlessEndTime!.format(context)
                                : 'Select End Time',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Patient Count: "),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: TextFormField(
                          controller: appointlessCountController,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
