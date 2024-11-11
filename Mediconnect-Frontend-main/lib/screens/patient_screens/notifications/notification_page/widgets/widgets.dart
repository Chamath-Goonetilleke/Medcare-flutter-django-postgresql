import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Notification widget for the Notifications Page
class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.notification_important, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

// View for Notifications
class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool isLoading = true;
  List<dynamic> notifications = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://13.60.21.117:8000/api/appointments/'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final data = jsonDecode(response.body);
      notifications = data['data'] as List;
      print("${notifications[0]['Disease']}");
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load doctors');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: const [
        NotificationCard(
          title: 'Appointment Reminder',
          subtitle: 'Your appointment with Dr. Smith is scheduled for tomorrow at 10:00 AM.',
        ),
        NotificationCard(
          title: 'New Message from Dr. Johnson',
          subtitle: 'You have a new message regarding your test results.',
        ),
        NotificationCard(
          title: 'Prescription Update',
          subtitle: 'Your prescription has been updated by Dr. Lee.',
        ),
      ],
    );
  }
}
