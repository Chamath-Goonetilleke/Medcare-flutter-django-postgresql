import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ElevatedButton available() {
  return ElevatedButton(
    onPressed: () {
      // Add your onPressed logic here
      if (kDebugMode) {
        print('Availble button pressed!');
      }
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.green.shade100,
    ),
    child: const Text(
      "Available",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
  );
}
