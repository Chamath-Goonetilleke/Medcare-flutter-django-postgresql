// import 'package:doctor/LoginPage/login.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/screens/common_screens/create_account%20&%20login/login/LoginScreen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const String firstName = "John";
    const String lastName = "Smith";
    const String fullName = "$firstName $lastName";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Expand settings section
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      // backgroundImage: AssetImage(
                      //     'assets/images/profile.jpg'), // replace with actual image asset
                    ),
                    SizedBox(height: 10),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'First name'),
                initialValue: "John",
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last name'),
                initialValue: "Smith",
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Other names'),
                initialValue: "James",
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Birthday',
                  hintText: 'Select Your Birthday',
                ),
                initialValue: "01/01/1990",
              ),
              const SizedBox(height: 20),
              const ListTile(
                leading: Icon(Icons.email),
                title: Text('johndoe@gmail.com'),
              ),
              const ListTile(
                leading: Icon(Icons.phone),
                title: Text('1234567891'),
              ),
              const ListTile(
                leading: Icon(Icons.location_on),
                title: Text('123 Main Street, New York, USA'),
              ),
              const ListTile(
                leading: Icon(Icons.work),
                title: Text('Software Engineer at ABC Company'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
