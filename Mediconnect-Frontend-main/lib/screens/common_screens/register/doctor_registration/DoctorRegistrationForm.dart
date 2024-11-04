import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mediconnect/repository/doctor_repository.dart';
import 'package:mediconnect/repository/doctor_visit_hospital.dart';
import 'package:mediconnect/repository/user_repository.dart';
import 'package:mediconnect/screens/common_screens/create_account%20&%20login/login/view/LoginScaffold.dart';
import 'package:mediconnect/screens/common_screens/register/doctor_registration/widgets/DoctorIDField.dart';
import 'package:mediconnect/screens/common_screens/register/doctor_registration/widgets/DoctorIDUpload.dart';
import 'package:mediconnect/screens/common_screens/register/doctor_registration/widgets/SpecializationDropdown.dart';
import 'package:mediconnect/screens/common_screens/register/doctor_registration/widgets/VisitingHospitalField.dart';
import 'package:mediconnect/screens/common_screens/register/widgets/register_button.dart';
import 'package:mediconnect/screens/doctor_screens/homepage/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_screens/register/widgets/address_fields.dart';
import '../../../common_screens/register/widgets/birthday_field.dart';
import '../../../common_screens/register/widgets/name_fields.dart';
import '../../../common_screens/register/widgets/nic_field.dart';

class DoctorRegistrationForm extends StatefulWidget {
  const DoctorRegistrationForm({super.key});

  @override
  _DoctorRegistrationFormState createState() => _DoctorRegistrationFormState();
}

class _DoctorRegistrationFormState extends State<DoctorRegistrationForm> {
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
  final _doctorIDController = TextEditingController();

  // Variables for dropdowns
  String? _selectedSpecialization;
  final List<Map<String, dynamic>> _hospitalDataList = [];
  List<VisitingHospitalField> _hospitalFields = []; // Initialize empty list

  final doctorRepository = DoctorRepository();
  final userRepository = UserRepository();
  final doctorVisitHospitalRepository = DoctorVisitHospitalRepository();

  String? _userId;

  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    _userId = userId;
  }

  void _onHospitalDataChanged(int index, Map<String, dynamic> data) {
    if (index < _hospitalDataList.length) {
      _hospitalDataList[index] = data;
    } else {
      _hospitalDataList.add(data);
    }
  }

  // Function to add a new hospital field
  void _addHospitalField() {
    setState(() {
      int newIndex = _hospitalFields.length;
      _hospitalFields.add(VisitingHospitalField(
        onHospitalDataChanged: (data) => _onHospitalDataChanged(newIndex, data),
        index: newIndex,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();

    // Initialize _hospitalFields here
    _hospitalFields = [
      VisitingHospitalField(
        onHospitalDataChanged: (data) => _onHospitalDataChanged(0, data),
        index: 0,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Registration')),
      body: RefreshIndicator(child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mediconnect.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    NameFields(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      otherNamesController: _otherNamesController,
                    ),
                    BirthdayField(
                      birthdayController: _birthdayController,
                    ),
                    AddressFields(
                      streetNoController: _streetNoController,
                      streetNameController: _streetNameController,
                      cityController: _cityController,
                      postalCodeController: _postalCodeController,
                    ),
                    NICField(nicController: _nicController),
                    SpecializationDropdown(
                      onSpecializationChanged: (value) {
                        setState(() {
                          _selectedSpecialization = value;
                        });
                      },
                      selectedSpecialization: _selectedSpecialization,
                    ),
                    DoctorIDField(
                      doctorIDController: _doctorIDController,
                    ),
                    const DoctorIDUpload(),
                    const SizedBox(height: 20),
                    Wrap(
                      children:[ Column(
                        children: _hospitalFields, // Display all hospital fields
                      )],
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          size: 30, color: Colors.green),
                      onPressed: _addHospitalField,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        var response = await doctorRepository.createDoctor(
                          doctor: jsonEncode({
                            'User_ID': _userId,
                            'First_name': _firstNameController.text,
                            'Last_name': _lastNameController.text,
                            'Other_name': _otherNamesController.text,
                            'Birthday': _birthdayController.text,
                            'Street_No': _streetNoController.text,
                            'Street_Name': _streetNameController.text,
                            'City': _cityController.text,
                            'Postal_Code': _postalCodeController.text,
                            'NIC': _nicController.text,
                            'Specialization': _selectedSpecialization,
                            'Reg_num': _doctorIDController.text,
                            'ID_photo': 123, // Dummy value for now
                          }),
                        );

                        if (response['status'] == "success") {
                          int doctorID = response['data']['Doctor_ID'];

                          List<Map<String, dynamic>> updatedHospitalDataList =
                              _hospitalDataList.map((hospital) {
                            return {
                              ...hospital,
                              'Doctor_ID': doctorID,
                            };
                          }).toList();

                          var dvh_response = await doctorVisitHospitalRepository
                              .createDoctorVisitHospital(
                                  visit: jsonEncode(updatedHospitalDataList));
                          if (dvh_response['status'] == "success") {
                            var res = await userRepository.changeRegStatus(
                                id: _userId!);
                            if (res['status'] == "success") {
                              var roleChangeRes = await userRepository
                                  .changeRole(id: _userId!, role: "Doctor");
                              if (roleChangeRes['status'] == "success") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScaffold()));
                              } else {
                                _showErrorDialog(context,
                                    roleChangeRes['message'].toString());
                              }
                            } else {
                              _showErrorDialog(
                                  context, res['message'].toString());
                            }
                          } else {
                            _showErrorDialog(
                                context, dvh_response['message'].toString());
                          }
                        } else {
                          _showErrorDialog(
                              context, response['message'].toString());
                        }
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
     onRefresh: (){
      return Future.value("");
      
    })
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
