import 'package:flutter/material.dart';
import 'package:mediconnect/repository/patient_repository.dart';
import 'package:mediconnect/repository/user_repository.dart';
import 'package:mediconnect/screens/common_screens/create_account%20&%20login/login/view/LoginScaffold.dart';
import 'package:mediconnect/screens/common_screens/register/widgets/address_fields.dart';
import 'package:mediconnect/screens/common_screens/register/widgets/birthday_field.dart';
import 'package:mediconnect/screens/common_screens/register/widgets/name_fields.dart';
import 'package:mediconnect/screens/common_screens/register/widgets/nic_field.dart';
import 'package:mediconnect/screens/common_screens/welcome/widgets/BackgroundImage.dart';
import '../../../../doctor_screens/homepage/home.dart';
import '../widgets/widgets.dart';
import 'package:mediconnect/screens/patient_screens/home/home_page/HomePage.dart'; // Import the Home Screen after registration
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PatientRegistrationScaffold extends StatefulWidget {
  const PatientRegistrationScaffold({super.key});

  @override
  _PatientRegistrationScaffoldState createState() =>
      _PatientRegistrationScaffoldState();
}

class _PatientRegistrationScaffoldState
    extends State<PatientRegistrationScaffold> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _otherNamesController = TextEditingController();
  final _streetNoController = TextEditingController();
  final _streetNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _nicController = TextEditingController();
  final _birthdayController = TextEditingController();
  final patientRepository = PatientRepository();
  final userRepository = UserRepository();
  // Variables for dropdowns and time pickers
  TimeOfDay? _breakfastTime;
  TimeOfDay? _lunchTime;
  TimeOfDay? _dinnerTime;

  Future<void> _registerUser() async {
    final url = Uri.parse('https://your-backend-url.com/api/register/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'other_names': _otherNamesController.text,
        'street_no': _streetNoController.text,
        'street_name': _streetNameController.text,
        'city': _cityController.text,
        'postal_code': _postalCodeController.text,
        'nic': _nicController.text,
        'birthday': _birthdayController.text,
        'breakfast_time': _breakfastTime?.format(context),
        'lunch_time': _lunchTime?.format(context),
        'dinner_time': _dinnerTime?.format(context),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      _showErrorDialog(context, 'Registration failed. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
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

  String? _userId;

  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    _userId = userId;
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
        title: const Text('Patient Registration'),
      ),
      body: Stack(
        children: [
          const BackgroundImage(), // Background Image
          Padding(
            padding:
                const EdgeInsets.all(16.0), // Use Padding instead of BlurredBox
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    NameFields(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      otherNamesController: _otherNamesController,
                    ),
                    const SizedBox(height: 20),
                    BirthdayField(birthdayController: _birthdayController),
                    const SizedBox(height: 20),
                    AddressFields(
                      streetNoController: _streetNoController,
                      streetNameController: _streetNameController,
                      cityController: _cityController,
                      postalCodeController: _postalCodeController,
                    ),
                    const SizedBox(height: 20),
                    NICField(nicController: _nicController),
                    const SizedBox(height: 20),
                    MealTimeFields(
                      breakfastTime: _breakfastTime,
                      lunchTime: _lunchTime,
                      dinnerTime: _dinnerTime,
                      onBreakfastChanged: (time) {
                        setState(() {
                          _breakfastTime = time;
                        });
                      },
                      onLunchChanged: (time) {
                        setState(() {
                          _lunchTime = time;
                        });
                      },
                      onDinnerChanged: (time) {
                        setState(() {
                          _dinnerTime = time;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var response =
                                await patientRepository.createPatient(
                                    patient: jsonEncode(<String, dynamic>{
                              "User_ID": _userId,
                              "First_name": _firstNameController.text,
                              "Last_name": _lastNameController.text,
                              "Other_name": _otherNamesController.text,
                              "Birthday": _birthdayController.text,
                              "Street_No": _streetNoController.text,
                              "Street_Name": _streetNameController.text,
                              "City": _cityController.text,
                              "Postal_Code": _postalCodeController.text,
                              "NIC": _nicController.text,
                              "Breakfast_time":
                                  _breakfastTime!.format(context).toString(),
                              "Lunch_time":
                                  _lunchTime!.format(context).toString(),
                              "Dinner_time":
                                  _dinnerTime!.format(context).toString()
                            }));
                            if (response['status'] == "success") {
                              var res = await userRepository.changeRegStatus(id: _userId!);
                              print(res);
                              if (res['status'] == "success") {
                                var roleChangeRes = await userRepository
                                    .changeRole(id: _userId!, role: "Patient");
                                if (roleChangeRes['status'] == "success") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginScaffold()));
                                } else {
                                  _showErrorDialog(context,
                                      roleChangeRes['message'].toString());
                                }
                              }
                              if (response['status'] == "error") {
                                _showErrorDialog(context, response['message']);
                              }
                              
                            }
                            if (response['status'] == "error") {
                              _showErrorDialog(context, response['message']);
                            }
                          }
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //              HomePage()),
                          //   );
                        },
                        child: const Text("Register"))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
