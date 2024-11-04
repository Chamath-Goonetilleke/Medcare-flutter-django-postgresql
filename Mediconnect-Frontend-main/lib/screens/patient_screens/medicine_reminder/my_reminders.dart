import 'package:flutter/material.dart';



class MyRemindersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reminders = [
    {
      'medicine': 'Panadol',
      'dose': '2 tablets',
      'time': '8:30 AM',
      'description': 'After breakfast',
      'isChecked': true,
      'image': 'assets/panadol.png'
    },
    {
      'medicine': 'Digene',
      'dose': '2 tablets',
      'time': '12:30 PM',
      'description': 'Before Lunch',
      'isChecked': false,
      'image': 'assets/digene.png'
    },
    {
      'medicine': 'Panadol',
      'dose': '2 tablets',
      'time': '9:00 PM',
      'description': 'After Dinner',
      'isChecked': false,
      'image': 'assets/panadol.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Date picker row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(9, (index) {
                return CircleAvatar(
                  backgroundColor: index == 4 ? Colors.green : Colors.grey[200],
                  child: Text('${index + 2}'),
                );
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    
                    title:
                        Text('${reminder['medicine']} - ${reminder['dose']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reminder['description']),
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
                      value: reminder['isChecked'],
                      onChanged: (value) {
                        // Implement functionality if needed
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
