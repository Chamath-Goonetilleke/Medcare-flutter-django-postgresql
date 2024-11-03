import 'package:flutter/material.dart';
import 'package:mediconnect/screens/patient_screens/medicine_reminder/medicine_reminder.dart';
import 'package:mediconnect/screens/patient_screens/prescriptions/prescriptions_page/pharmacy_use/select_medicine/SelectMedicine.dart'; // Import routing

class PrescriptionCard extends StatelessWidget {
  final Map<String, dynamic> prescription;

  const PrescriptionCard({Key? key, required this.prescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Redirect to the Select Medicine page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineReminder(prescription: prescription),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prescription['date'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                prescription['doctor'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              ...prescription['medications'].map<Widget>((medication) {
                return Text(
                  medication,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: prescription['progress'] / 100,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${prescription['progress']}%'),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                children: prescription['keywords'].map<Widget>((keyword) {
                  return Chip(
                    label: Text(keyword),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
