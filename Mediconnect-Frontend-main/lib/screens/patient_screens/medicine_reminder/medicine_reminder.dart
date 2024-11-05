import 'package:flutter/material.dart';
import 'package:mediconnect/screens/patient_screens/medicine_reminder/my_reminders.dart';
import 'package:mediconnect/screens/patient_screens/medicine_reminder/set_reminder.dart';
import 'package:mediconnect/screens/patient_screens/prescriptions/prescriptions_page/pharmacy_use/select_medicine/SelectMedicine.dart'; // Import routing

class MedicineReminder extends StatefulWidget {
  final Map<String, dynamic> prescription;

  const MedicineReminder({ Key? key, required this.prescription }) : super(key: key);

  @override
  _MedicineReminderState createState() => _MedicineReminderState();
}

class _MedicineReminderState extends State<MedicineReminder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:3, // We have 2 tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Medical Records'),
          bottom: const TabBar(
            indicatorColor: Colors.blue, // Underline color of selected tab
            labelColor: Colors.blue, // Color of selected tab label
            unselectedLabelColor: Colors.grey, // Unselected tab label color
            tabs: [
              Tab(text: 'Set Reminder'),
              Tab(text: 'My Reminder'),
              Tab(text: 'For Pharmacy Use'),
            ],
          ),
          backgroundColor: Colors.white, // AppBar background color
        ),
        body: TabBarView(
          children: [
           ReminderScreen(prescription: widget.prescription),
           MyRemindersScreen(prescription: widget.prescription),
           SelectMedicinePage(prescription: widget.prescription)

          ],
        ),
      ),
    );
  }
}