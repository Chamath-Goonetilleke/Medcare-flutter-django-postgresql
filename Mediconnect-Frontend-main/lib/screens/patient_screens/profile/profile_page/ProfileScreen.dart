import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../common_screens/create_account & login/login/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showRemoveAccountDialog(BuildContext context, String userName) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type "Remove $userName" to confirm'),
              const SizedBox(height: 10),
              TextField(controller: controller),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text == 'Remove $userName') {
                  // Perform account removal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } else {
                  // Show error message or do nothing
                }
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  Map<String, dynamic>? patient;
  bool isLoading = true;
  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final uri =
        Uri.parse("http://10.0.2.2:8000/api/patient/getByUserId/$userId");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        patient = data['data'];
        isLoading = false;
      });
      
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading ? const Center(child: CircularProgressIndicator(),): SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/profile.jpg'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${patient!['First_name']} ${patient!['Last_name']}",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.cake),
                      title: Text("${patient!['Birthday']}"),
                    ),
                    ListTile(
                      leading: Icon(Icons.person_2_rounded),
                      title: Text("${patient!['NIC']}"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('0751234545'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(
                          "${patient!['Street_No']}, ${patient!['Street_Name']}, ${patient!['City']}"),
                    ),
                    const SizedBox(height: 20),
                    const Text('Settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ExpansionTile(
                      title: const Text('Notifications'),
                      children: [
                        ListTile(
                          title: const Text('Notification Type'),
                          trailing: DropdownButton(
                            items: const [
                              DropdownMenuItem(
                                value: 'Mute',
                                child: Text('Mute'),
                              ),
                              DropdownMenuItem(
                                value: 'Vibrate',
                                child: Text('Vibrate'),
                              ),
                              DropdownMenuItem(
                                value: 'Sound',
                                child: Text('Sound'),
                              ),
                            ],
                            onChanged: (value) {
                              // Handle notification type change
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Notification Sound'),
                          trailing: DropdownButton(
                            items: const [
                              DropdownMenuItem(
                                value: 'Default',
                                child: Text('Default'),
                              ),
                              DropdownMenuItem(
                                value: 'Chime',
                                child: Text('Chime'),
                              ),
                              DropdownMenuItem(
                                value: 'Bell',
                                child: Text('Bell'),
                              ),
                            ],
                            onChanged: (value) {
                              // Handle notification sound change
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Vibration Type'),
                          trailing: DropdownButton(
                            items: const [
                              DropdownMenuItem(
                                value: 'Short',
                                child: Text('Short'),
                              ),
                              DropdownMenuItem(
                                value: 'Long',
                                child: Text('Long'),
                              ),
                              DropdownMenuItem(
                                value: 'Pattern',
                                child: Text('Pattern'),
                              ),
                            ],
                            onChanged: (value) {
                              // Handle vibration type change
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Language'),
                          trailing: DropdownButton(
                            items: const [
                              DropdownMenuItem(
                                value: 'English',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'Spanish',
                                child: Text('Spanish'),
                              ),
                            ],
                            onChanged: (value) {
                              // Handle language change
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Log Out'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _showRemoveAccountDialog(context, "${patient!['First_name']} ${patient!['Last_name']}"),
                      child: const Text('Remove Account'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ),
     
      ),
    );
  }
}
