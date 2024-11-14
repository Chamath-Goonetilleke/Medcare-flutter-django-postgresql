import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mediconnect/screens/doctor_screens/doctormain.dart';
import 'package:mediconnect/screens/patient_screens/home/home_page/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../create_account & login/login/LoginScreen.dart'; // Import RegisterScreen
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForegroundContent extends StatefulWidget {
  const ForegroundContent({super.key});

  @override
  State<ForegroundContent> createState() => _ForegroundContentState();
}

class _ForegroundContentState extends State<ForegroundContent> {
  String? _deviceId;
  bool isLoggedIn = true;

  Future getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');

    if (deviceId == null) {
      // Generate a random unique ID (you can use any approach here)
      deviceId = _generateRandomId();
      await prefs.setString('device_id', deviceId);
    }

    final response = await http
        .get(Uri.parse('http://13.49.21.193:8000/api/users/device/$deviceId/'));
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setUserID(data['data']['User_ID'].toString());
      if (data['data']['Role'] == "Patient") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (data['data']['Role'] == "Doctor") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorHomeScreen()),
        );
      }
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }

    setState(() {
      _deviceId = deviceId;
    });
  }

  Future setUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
  }

  String _generateRandomId() {
    var random = Random();
    return List.generate(16, (index) => random.nextInt(9).toString()).join();
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.65), // Semi-transparent overlay
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0, // Remove shadow
              title: const Text(
                'Welcome',
                style:
                    TextStyle(color: Colors.white), // White text for contrast
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'MediConnect',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color for contrast
                      ),
                    ),
                    const Text(
                      'Your Healthcare Companion',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white, // Text color for contrast
                      ),
                    ),
                    const SizedBox(height: 30),
                    isLoggedIn
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            child: const Text(
                              'Get Started',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
