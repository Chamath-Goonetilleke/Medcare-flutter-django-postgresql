import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediconnect/repository/prescription_repository.dart';

class AddPrescriptionScreen extends StatefulWidget {
  final Map<String, dynamic> presDetails;
  const AddPrescriptionScreen({Key? key, required this.presDetails})
      : super(key: key);

  @override
  _AddPrescriptionScreenState createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final List<Map<String, dynamic>> medicines = [];
  final List<String> keywords = [];
  String selectedDiagnosis = '';
  bool isHide = false;
  final PrescriptionRepository _prescriptionRepository =
      PrescriptionRepository();

  void _addMedicine() {
    setState(() {
      medicines.add({
        'medicine': 'Paracetamol',
        'strength': 5,
        'strengthUnit': 'mg',
        'quantity': 10,
        'quantityUnit': 'tablets',
        'duration': 1,
        'durationUnit': 'days',
      });
    });
  }

  List<Map<String, dynamic>> _setKeyword(int prescriptionId) {
    List<Map<String, dynamic>> keywordData = keywords.map((key) {
      return {"Prescription_ID": prescriptionId, "Keyword": key};
    }).toList();
    return keywordData;
  }

  List<Map<String, dynamic>> _setMedicine(int prescriptionId) {
    List<Map<String, dynamic>> medicineData = medicines.map((med) {
      return {
        "Prescription_ID": prescriptionId,
        "Medicine": med['medicine'],
        "Quantity": "${med['quantity']} ${med['quantityUnit']}",
        "Strength": "${med['strength']} ${med['strengthUnit']}",
        "Duration": "${med['duration']} ${med['durationUnit']}"
      };
    }).toList();
    return medicineData;
  }

  void _submitData() async {
    Map<String, dynamic> prescription = {
      "Doctor_ID": widget.presDetails['docId'],
      "Patient_ID": widget.presDetails['patientId'],
      "Date": DateTime.now().toString(),
      "IsHide": isHide
    };

    final presResponse = await _prescriptionRepository.createPrescription(
        prescription: jsonEncode(prescription));

    if (presResponse['status'] == "success") {
      List<Map<String, dynamic>> keywordData =
          _setKeyword(presResponse['data']['Prescription_ID']);
      List<Map<String, dynamic>> medicineData =
          _setMedicine(presResponse['data']['Prescription_ID']);
      print(keywordData);
      print(medicineData);
      final mediResponse = await _prescriptionRepository.createMedicine(
          medicine: jsonEncode(medicineData));
      if (mediResponse['status'] == "success") {
        final keywordResponse = await _prescriptionRepository.createKeywords(
            keyword: jsonEncode(keywordData));
        if (keywordResponse['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription Added Successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error Adding Keywords')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error Adding Medicine')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error Adding Prescription')),
      );
    }
  }

  void _addKeyword() {
    if (selectedDiagnosis.isNotEmpty && !keywords.contains(selectedDiagnosis)) {
      setState(() {
        keywords.add(selectedDiagnosis);
        selectedDiagnosis = ''; // Clear the selection after adding
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _addMedicine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Prescription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Diagnosis Dropdown
            DropdownButtonFormField<String>(
              value: selectedDiagnosis.isEmpty ? null : selectedDiagnosis,
              items: ['Gastritis', 'Cold', 'Fever', 'Headache', 'Allergy']
                  .map((diagnosis) => DropdownMenuItem(
                        value: diagnosis,
                        child: Text(diagnosis),
                      ))
                  .toList(),
              hint: const Text('Select Diagnosis'),
              onChanged: (value) {
                setState(() {
                  selectedDiagnosis = value!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Add Keyword Button
            ElevatedButton(
              onPressed: _addKeyword,
              child: const Text('Add Keyword'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),

            // Display Keywords as Chips
            Wrap(
              children: keywords
                  .map<Widget>((keyword) => Chip(
                        label: Text(keyword),
                        backgroundColor: Colors.redAccent,
                        labelStyle: const TextStyle(color: Colors.white),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 20),

            // List of Medicine sections
            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  return _buildMedicineSection(index);
                },
              ),
            ),
            const SizedBox(height: 10),

            // "Add More Medicines" Button
            ElevatedButton.icon(
              onPressed: _addMedicine,
              icon: const Icon(Icons.add),
              label: const Text("Add More Medicines"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),

            // Hide Prescription Checkbox and Done Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: isHide,
                        onChanged: (bool? value) {
                          setState(() {
                            isHide = !isHide;
                          });
                        }),
                    const Text("Hide Prescription"),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text("Done"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Medicine Section Builder
  Widget _buildMedicineSection(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Medicine Dropdown
            DropdownButtonFormField<String>(
              value: medicines[index]['medicine'],
              items: ['Paracetamol', 'Ibuprofen', 'Amoxicillin']
                  .map((medicine) => DropdownMenuItem(
                        value: medicine,
                        child: Text(medicine),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  medicines[index]['medicine'] = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Select Medicine'),
            ),
            const SizedBox(height: 10),

            // Strength and Unit
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: medicines[index]['strength'],
                    items: [5, 10, 15, 20]
                        .map((strength) => DropdownMenuItem(
                              value: strength,
                              child: Text(strength.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        medicines[index]['strength'] = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Strength'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: medicines[index]['strengthUnit'],
                    items: ['mg', 'g', 'ml']
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        medicines[index]['strengthUnit'] = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Unit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Quantity and Unit
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: medicines[index]['quantity'],
                    items: [10, 20, 30, 40]
                        .map((quantity) => DropdownMenuItem(
                              value: quantity,
                              child: Text(quantity.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        medicines[index]['quantity'] = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: medicines[index]['quantityUnit'],
                    items: ['tablets', 'capsules']
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        medicines[index]['quantityUnit'] = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Unit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Duration and Unit
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: medicines[index]['duration'],
                    items: [1, 3, 5, 7]
                        .map((duration) => DropdownMenuItem(
                              value: duration,
                              child: Text(duration.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        medicines[index]['duration'] = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Duration'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: medicines[index]['durationUnit'],
                    items: ['days', 'weeks', 'months']
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        medicines[index]['durationUnit'] = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Unit'),
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
