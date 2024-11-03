import 'package:flutter/material.dart';
import 'package:mediconnect/models/MedicineReminder.dart';
import 'package:mediconnect/repository/reminder_repository.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final ReminderRepository apiService = ReminderRepository();
  late Future<List<MedicineReminder>> reminders;
  final List<MedicineReminder> sampleReminders = [
    MedicineReminder(
      medicineId: 1,
      medicine: "Panadol",
      strength: "5mg",
      interval: "6 hours",
      timesPerDay: null,
      beforeMeal: true,
      afterMeal: false,
      quantity: "2 pills",
      turnOffAfter: "8 weeks",
      notes: "Take with water",
    ),
    MedicineReminder(
      medicineId: 2,
      medicine: "Digene",
      strength: "5mg",
      interval: null,
      timesPerDay: 4,
      beforeMeal: true,
      afterMeal: false,
      quantity: "1 pill",
      turnOffAfter: "4 weeks",
      notes: "Avoid acidic food",
    ),
    MedicineReminder(
      medicineId: 3,
      medicine: "Pantodac",
      strength: "15mg",
      interval: "8 hours",
      timesPerDay: null,
      beforeMeal: false,
      afterMeal: true,
      quantity: "1 pill",
      turnOffAfter: "6 weeks",
      notes: "Do not crush the pill",
    ),
  ];

  @override
  void initState() {
    super.initState();
    //reminders = apiService.fetchReminders();
    reminders = Future.value(sampleReminders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MedicineReminder>>(
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
  final ReminderRepository apiService = ReminderRepository();
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

      print(widget.reminder.toJson());
      // await apiService.saveReminder(widget.reminder);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder saved successfully')));
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
              child: const Text('Save Reminder'),
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
