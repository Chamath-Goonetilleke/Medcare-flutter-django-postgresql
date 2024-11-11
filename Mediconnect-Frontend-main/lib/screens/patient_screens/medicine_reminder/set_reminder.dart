import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediconnect/models/MedicineReminder.dart';
import 'package:mediconnect/repository/pharmacy_repository.dart';
import 'package:mediconnect/repository/reminder_repository.dart';
import 'package:http/http.dart' as http;

class ReminderScreen extends StatefulWidget {
  final Map<String, dynamic> prescription;

  const ReminderScreen({super.key, required this.prescription});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isLoading = true;
  late Future<List<MedicineReminder>> reminders;
  final List<MedicineReminder> sampleReminders = [];

  void getMedicineIds() async {
    List<MedicineReminder> results =
        []; // Step 1: Initialize an empty list to store results
        print(widget.prescription);
    List<Future<void>> requests =
        widget.prescription['medications'].map<Future<void>>((med) async {
      final uri = Uri.parse("http://13.60.21.117:8000/api/pharmacy/${med['id']}");
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (data['status'] == "success" &&
          data['data']['IsReminderSet'] == false) {

        
        results.add(MedicineReminder(
          medicineId: data['data']['Medicine_ID']['Medicine_ID'],
          medicine: data['data']['Medicine_ID']['Medicine'],
          strength: data['data']['Medicine_ID']['Strength'],
          interval: data['data']['Interval'],
          timesPerDay: data['data']['Times_per_day'],
          beforeMeal: data['data']['Before_meal'],
          afterMeal: data['data']['After_meal'],
          quantity: data['data']['Quantity'],
          turnOffAfter: data['data']['Turn_off_after'],
          notes: data['data']['Notes'],
        )); // Step 2: Add the data to the results listr
      }
    }).toList(); // Ensure toList() is called on the entire map

    await Future.wait(requests); // Wait for all requests to complete

    setState(() {
      reminders = Future.value(results);
      isLoading = false;
    }); // Step 3: Print the results array
  }

  @override
  void initState() {
    super.initState();
    //reminders = _reminderRepository.fetchReminders();
    //reminders = Future.value(sampleReminders);
    getMedicineIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator(),): FutureBuilder<List<MedicineReminder>>(
              future: reminders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reminders found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final reminder = snapshot.data![index];
                    return ReminderCard(reminder: reminder);
                  },
                );
              },
            ),
    
    );
  }
}

class ReminderCard extends StatefulWidget {
  final MedicineReminder reminder;

  ReminderCard({required this.reminder});

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  final ReminderRepository _reminderRepository = ReminderRepository();
  final PharmacyRepository _pharmacyRepository = PharmacyRepository();
  late List<TimeOfDay?> selectedTimes;

  @override
  void initState() {
    super.initState();

    // Initialize selectedTimes based on interval or timesPerDay.
    if (widget.reminder.interval != null) {
      // If interval is specified, initialize with two elements for start and end times.
      selectedTimes = List.filled(2, null);
    } else if (widget.reminder.timesPerDay != null) {
      // If timesPerDay is specified, initialize with that many elements.
      selectedTimes = List.filled(widget.reminder.timesPerDay!, null);
    } else {
      // Default to an empty list if neither interval nor timesPerDay is specified.
      selectedTimes = [];
    }
  }

  void _saveReminder() async {
    try {
      // Update reminder fields before saving
      if (widget.reminder.interval != null) {
        // Set startTime and endTime if interval is specified
        widget.reminder.startTime =
            selectedTimes.isNotEmpty ? selectedTimes[0] : null;
        widget.reminder.endTime =
            selectedTimes.length > 1 ? selectedTimes[1] : null;
      } else if (widget.reminder.timesPerDay != null) {
        // Set selectedTimes for times-per-day reminders
        widget.reminder.selectedTimes = selectedTimes;
      }

      List<Map<String, dynamic>>  reminders=[];
      if(widget.reminder.interval != null) { 
       reminders.add({
        "Medicine_ID":widget.reminder.medicineId,
        "time":"${widget.reminder.startTime!.hour.toString().padLeft(2, '0')}.${widget.reminder.startTime!.minute.toString().padLeft(2, '0')}",
        "quantity":widget.reminder.quantity,
        "after_meal":widget.reminder.afterMeal,
        "before_meal":widget.reminder.beforeMeal
       });
       reminders.add({
          "Medicine_ID": widget.reminder.medicineId,
          "time": "${widget.reminder.endTime!.hour.toString().padLeft(2, '0')}.${widget.reminder.endTime!.minute.toString().padLeft(2, '0')}",
          "quantity": widget.reminder.quantity,
          "after_meal": widget.reminder.afterMeal,
          "before_meal": widget.reminder.beforeMeal
        });
      }
      if(widget.reminder.timesPerDay != null){
        
        for (var selectedTime in selectedTimes) {
          reminders.add({
            "Medicine_ID": widget.reminder.medicineId,
            "time": "${selectedTime!.hour.toString().padLeft(2, '0')}.${selectedTime.minute.toString().padLeft(2, '0')}",
            "quantity": widget.reminder.quantity,
            "after_meal": widget.reminder.afterMeal,
            "before_meal": widget.reminder.beforeMeal
          });
        }

      }
      print(reminders);
      final response = await _reminderRepository.createReminder(reminder: jsonEncode(reminders));
      if(response['status'] =="success"){
        final res = await _pharmacyRepository.updatePharmacy(pharmacy: jsonEncode({"IsReminderSet": true}), pharmacyId: widget.reminder.medicineId);
        if(res['status'] =="success"){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reminder Saved Successfully')));
        }
        
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save reminder: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.reminder.medicine} - ${widget.reminder.strength}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Intake: ${widget.reminder.interval}'),
            if (widget.reminder.beforeMeal) const Text('Before meal'),
            if (widget.reminder.afterMeal) const Text('After meal'),

            // Interval-based dropdowns for start and end times
            if (widget.reminder.interval != null) ...[
              const Text('Starting at'),
              DropdownButton<TimeOfDay>(
                value: selectedTimes.isNotEmpty ? selectedTimes[0] : null,
                items: _buildTimeDropdownItems(),
                onChanged: (value) => setState(() {
                  if (selectedTimes.isNotEmpty) selectedTimes[0] = value;
                }),
              ),
              const Text('Ending at'),
              DropdownButton<TimeOfDay>(
                value: selectedTimes.length > 1 ? selectedTimes[1] : null,
                items: _buildTimeDropdownItems(),
                onChanged: (value) => setState(() {
                  if (selectedTimes.length > 1) selectedTimes[1] = value;
                }),
              ),
            ],

            // Times-per-day dropdowns
            if (widget.reminder.timesPerDay != null) ...[
              Text('Select times per day: ${widget.reminder.timesPerDay}'),
              for (int i = 0; i < widget.reminder.timesPerDay!; i++)
                DropdownButton<TimeOfDay>(
                  value: i < selectedTimes.length ? selectedTimes[i] : null,
                  items: _buildTimeDropdownItems(),
                  onChanged: (value) => setState(() {
                    if (i < selectedTimes.length) selectedTimes[i] = value;
                  }),
                ),
            ],

            ElevatedButton(
              onPressed: _saveReminder,
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<TimeOfDay>> _buildTimeDropdownItems() {
    return List.generate(
      24,
      (index) => DropdownMenuItem(
        value: TimeOfDay(hour: index, minute: 0),
        child: Text('${index.toString().padLeft(2, '0')}:00'),
      ),
    );
  }
}
