import 'package:flutter/material.dart';
import 'package:mediconnect/screens/patient_screens/prescriptions/prescriptions_page/pharmacy_use/set_instructions/view/SetInstructionsScaffold.dart';

class SetInstructionsPage extends StatelessWidget {
  final Map<String, dynamic> medication;

  const SetInstructionsPage({Key? key, required this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SetInstructionsScaffold(medication: medication, instructions: {},);
  }
}
