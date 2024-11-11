import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../medicine_reminders/widgets/widgets.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPageScaffold extends StatefulWidget {
  const NotificationsPageScaffold({Key? key}) : super(key: key);

  @override
  State<NotificationsPageScaffold> createState() =>
      _NotificationsPageScaffoldState();
}

class _NotificationsPageScaffoldState extends State<NotificationsPageScaffold> {
  bool isLoading = true;
  List<dynamic> notifications = [];

    Future<void> getDoctorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final uri =
        Uri.parse("http://13.60.21.117:8000/api/patient/getByUserId/$userId");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      print(data);
      final notifiResponse = await http.get(Uri.parse(
          'http://13.60.21.117:8000/api/notes/patient/${data['data']['Patient_ID']}'));
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
