import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ElevatedButton confrim(String value) {
  return ElevatedButton(
    onPressed: () {
      // Add your onPressed logic here
      if (kDebugMode) {
        print('$value button pressed!');
      }
    },
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(50, 25),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(70),
      ),
      backgroundColor: Colors.lightBlue.shade100,
    ),
    child: const Text(
      "Confrim Pre-planned",
      style: TextStyle(fontSize: 10, color: Colors.black),
    ),
  );
}
