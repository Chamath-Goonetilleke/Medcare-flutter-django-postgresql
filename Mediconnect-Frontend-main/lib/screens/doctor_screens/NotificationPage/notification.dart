import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isLoading = true;
  List<dynamic> notifications = [];

  Future<void> getDoctorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final uri =
        Uri.parse("http://10.0.2.2:8000/api/doctors/getByUserId/$userId");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      final notifiResponse = await http.get(Uri.parse(
          'http://10.0.2.2:8000/api/notes/doctor/${data['data']['Doctor_ID']}'));
      if (notifiResponse.statusCode == 200) {
        final notifiData = jsonDecode(notifiResponse.body);
        print(notifiData);
        setState(() {
          notifications = notifiData['data'];

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load doctors');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDoctorDetails();
  }

@override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : notifications.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            leading: const Icon(
                              Icons.notification_important,
                              color: Colors.blue,
                            ),
                            subtitle: Text(notification['Note']),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No notifications"),
                      ],
                    ),
                  ),
      ),
    );
  }

}
