import 'package:flutter/material.dart';
import '../widgets/MedicineCard.dart';

class SelectMedicineScaffold extends StatelessWidget {
  final Map<String, dynamic> prescription;

  const SelectMedicineScaffold({Key? key, required this.prescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: prescription['medications'].length,
        itemBuilder: (context, index) {
          final medication = prescription['medications'][index];
          return MedicineCard(medication: medication);
        },
      ),
    );
  }
}
