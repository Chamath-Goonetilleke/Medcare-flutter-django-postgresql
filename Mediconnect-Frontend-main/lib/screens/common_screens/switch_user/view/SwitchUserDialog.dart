import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediconnect/screens/common_screens/create_account%20&%20login/login/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart'; // Import the widgets

class SwitchUserDialog extends StatefulWidget {
  const SwitchUserDialog({super.key});

  @override
  _SwitchUserDialogState createState() => _SwitchUserDialogState();
}

class _SwitchUserDialogState extends State<SwitchUserDialog> {
  List<dynamic> users = [];
  bool isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    String? userId = prefs.getString('user_id');
    try {
      final response = await http.get(Uri.parse(
          'http://13.49.21.193:8000/api/users/all-device-users/$deviceId/')); // Update with your actual API endpoint

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['data']);
        setState(() {
          _userId = userId;
          users = data[
              'data']; // Assume 'users' is a list of user objects returned from the backend
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Switch Account'),
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isNotEmpty
              ? SingleChildScrollView(
                  child: ListBody(
                    children: users.map((user) {
                      if (user['User_ID'].toString() != _userId) {
                        return UserListTile(
                          name: user['Device_ID'],
                          email: user['Email'],
                          role: user['Role'],
                          onTap: () {
                            // Handle switching to this account
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  ),
                )
              : const Center(
                  child: Text("No other accounts"),
                ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
