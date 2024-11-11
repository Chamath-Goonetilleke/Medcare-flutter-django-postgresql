import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRemindersScreen extends StatefulWidget {
  final Map<String, dynamic> prescription;
  const MyRemindersScreen({super.key, required this.prescription});
  @override
  State<MyRemindersScreen> createState() => _MyRemindersScreenState();
}

class _MyRemindersScreenState extends State<MyRemindersScreen> {
  bool isLoading = true;
  List<dynamic> reminders = [
    // {
    //   'medicine': 'Panadol',
    //   'dose': '2 tablets',
    //   'time': '8:30 AM',
    //   'description': 'After breakfast',
    //   'isChecked': true,
    //   'image': 'assets/panadol.png'
    // },
    // {
    //   'medicine': 'Digene',
    //   'dose': '2 tablets',
    //   'time': '12:30 PM',
    //   'description': 'Before Lunch',
    //   'isChecked': false,
    //   'image': 'assets/digene.png'
    // },
    // {
    //   'medicine': 'Panadol',
    //   'dose': '2 tablets',
    //   'time': '9:00 PM',
    //   'description': 'After Dinner',
    //   'isChecked': false,
    //   'image': 'assets/panadol.png'
    // },
  ];

  Future<void> _fetchReminders() async {
    final response = await http.get(Uri.parse(
        'http://13.60.21.117:8000/api/reminders/daily/${widget.prescription['id']}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        reminders = data['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load medical centers');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : reminders.length > 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = reminders[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(
                                  '${reminder['Medicine_ID']['Medicine']} - ${reminder['Medicine_ID']['Quantity']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(reminder['before_meal']
                                      ? "Before Meal"
                                      : reminder['after_meal']
                                          ? "After Meal"
                                          : ""),
                                  Row(
                                    children: [
                                      const Icon(Icons.notifications, size: 18),
                                      const SizedBox(width: 5),
                                      Text(reminder['time']),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Checkbox(
                                value: reminder['is_active'],
                                onChanged: (value) {
                                  // Implement functionality if needed
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Column(
                    
                      children: [
                        SizedBox(height: 60),
                        Center(
                          child: Text("No Reminders Set"),
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
