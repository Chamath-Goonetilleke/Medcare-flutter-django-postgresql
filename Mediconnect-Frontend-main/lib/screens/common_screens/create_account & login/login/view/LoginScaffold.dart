import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediconnect/repository/user_repository.dart';
import 'package:mediconnect/screens/common_screens/create_account%20&%20login/widgets/facebook_sign_in_button.dart';
import 'package:mediconnect/screens/common_screens/role_selection/RoleSelection.dart';
import 'package:mediconnect/screens/doctor_screens/doctormain.dart';
import 'package:mediconnect/screens/doctor_screens/homepage/home.dart';
import 'package:mediconnect/screens/patient_screens/home/home_page/HomePage.dart';
import '../../widgets/widgets.dart';
//import '../role_selection/role_selection_screen.dart'; // Import role selection screen
import 'package:shared_preferences/shared_preferences.dart';

class LoginScaffold extends StatefulWidget {
  const LoginScaffold({super.key});

  @override
  State<LoginScaffold> createState() => _LoginScaffoldState();
}

class _LoginScaffoldState extends State<LoginScaffold> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final userRepository = UserRepository();

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future setUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(), // Use the background image
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                // Title at the top
                const Padding(
                  padding:
                      EdgeInsets.only(top: 50.0), // Add padding from the top
                  child: Text(
                    'Login to Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: BlurredBox(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // Reduce the box size based on content
                          children: [
                            TextField(
                              style: const TextStyle(
                                  color:
                                      Colors.white), // White text for contrast
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                              controller: _emailController,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                              controller: _passwordController,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                var response = await userRepository.loginUser(
                                    user: jsonEncode(<String, String>{
                                  "Email": _emailController.text,
                                  "Password": _passwordController.text
                                }));
                                if (response['status'] == "success") {
                                  setUserID(response['data']['User_ID'].toString());
                                  if (response['data']['IsRegistered']) {
                                    if(response['data']['Role'] == "Patient"){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                      );
                                    }
                                    else if (response['data']['Role'] == "Doctor") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const DoctorHomeScreen()),
                                      );
                                    }
                                    else{
                                      _showErrorDialog(
                                          context, "Role is not set");
                                    }

                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RoleSelectionScreen()),
                                    );
                                  }
                                }
                                if (response['status'] == "error") {
                                  _showErrorDialog(
                                      context, response['message']);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 20),
                            const Text('Or',
                                style: TextStyle(color: Colors.black)),
                            const SizedBox(height: 10),
                            GoogleSignInButton(),
                            const SizedBox(height: 10),
                            FacebookSignInButton(),
                            const SizedBox(height: 20),
                            const Text('Do not have an account?',
                                style: TextStyle(color: Colors.black)),
                            const CreateAnAccount(),
                            const SizedBox(height: 20),
                            // Bypass Login Button
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               const RoleSelectionScreen()),
                            //     );
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.blueAccent,
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 50, vertical: 15),
                            //   ),
                            //   child: const Text(
                            //     'Bypass Login',
                            //     style: TextStyle(
                            //         fontSize: 16, color: Colors.white),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
