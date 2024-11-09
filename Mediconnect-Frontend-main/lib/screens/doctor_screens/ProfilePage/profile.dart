// import 'package:doctor/LoginPage/login.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/screens/common_screens/create_account%20&%20login/login/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? doctor;
  bool isLoading = true;

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
      setState(() {
        doctor = data['data'];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDoctorDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Expand settings section
            },
          ),
        ],
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),): Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            // backgroundImage: AssetImage(
                            //     'assets/images/profile.jpg'), // replace with actual image asset
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${doctor!['First_name']} ${doctor!['Last_name']}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'First name'),
                      initialValue: "${doctor!['First_name']}",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last name'),
                      initialValue: "${doctor!['Last_name']}",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Other names'),
                      initialValue: "${doctor!['Other_name']}",
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Birthday',
                        hintText: 'Select Your Birthday',
                      ),
                      initialValue: "${doctor!['Birthday']}",
                    ),
                    const SizedBox(height: 20),

                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(
                          "${doctor!['Street_No']}, ${doctor!['Street_Name']}, ${doctor!['City']}"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.work),
                      title: Text("${doctor!['Specialization']}"),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Settings',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ExpansionTile(
                      title: const Text('Notifications'),
                      children: [
                        ListTile(
                          title: const Text('Notification Type'),
                          trailing: DropdownButton(
                            value: 'Mute',
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
                            value: 'Default',
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
                            value: 'Short',
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
                            value: 'English',
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
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
   
   );
  }
}
