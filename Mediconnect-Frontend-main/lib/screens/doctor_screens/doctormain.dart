// import 'package:doctor/NotificationPage/notification.dart';
// import 'package:doctor/ProfilePage/profile.dart';
// import 'package:doctor/TaskPage/mytask.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediconnect/screens/doctor_screens/NotificationPage/notification.dart';
import 'package:mediconnect/screens/doctor_screens/ProfilePage/profile.dart';
import 'package:mediconnect/screens/doctor_screens/TaskPage/mytask.dart';
import 'package:mediconnect/screens/doctor_screens/StatsPage/bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage/home.dart';
import 'package:http/http.dart' as http;

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  static final List<Widget> _widgetOptions = <Widget>[
    const TaskPage(),
    const Barchart(),
    const Home(),
    const Notifications(),
    const Profile(),
  ];

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          _buildBottomNavigationBarItem(Icons.edit_calendar, 'Schedule'),
          _buildBottomNavigationBarItem(Icons.bar_chart, 'Stats'),
          _buildBottomNavigationBarItem(Icons.home, 'Home'),
          _buildBottomNavigationBarItem(Icons.notifications, 'Notifications'),
          _buildBottomNavigationBarItem(Icons.person, 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(41, 145, 168, 1),
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: _onItemTapped,
      ),
    );
  }
}
