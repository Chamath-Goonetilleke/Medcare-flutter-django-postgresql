import 'package:flutter/material.dart';
import 'package:mediconnect/screens/patient_screens/prescriptions/prescriptions_page/pharmacy_use/set_instructions/SetInstructions.dart';
//import 'package:mediconnect/screens/patient_screens/prescriptions/prescriptions_page/pharmacy_use/set_instructions/view/set_instructions_page.dart';

class MedicineCard extends StatelessWidget {
  final Map<String, dynamic> medication;

  const MedicineCard({Key? key, required this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the SetInstructionsPage with the medication name as an argument
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetInstructionsPage(medication: medication),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListTile(
          title: Text(
            medication['text'].toString(),
            style: const TextStyle(fontSize: 16),
          ),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
