import 'package:flutter/material.dart';

class MedicineReminder {
  final int medicineId;
  final String medicine;
  final String strength;
  final String? interval;
  final int? timesPerDay;
  final bool beforeMeal;
  final bool afterMeal;
  final String quantity;
  final String turnOffAfter;
  final String notes;

  // New fields for storing selected times
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<TimeOfDay?> selectedTimes;

  MedicineReminder({
    required this.medicineId,
    required this.medicine,
    required this.strength,
    required this.interval,
    this.timesPerDay,
    required this.beforeMeal,
    required this.afterMeal,
    required this.quantity,
    required this.turnOffAfter,
    required this.notes,
    this.startTime,
    this.endTime,
    List<TimeOfDay?>? selectedTimes,
  }) : selectedTimes = selectedTimes ?? [];

  factory MedicineReminder.fromJson(Map<String, dynamic> json) {
    return MedicineReminder(
      medicineId: json['Medicine_ID']['Medicine_ID'],
      medicine: json['Medicine_ID']['Medicine'],
      strength: json['Medicine_ID']['Strength'],
      interval: json['Interval'],
      timesPerDay: json['Times_per_day'],
      beforeMeal: json['Before_meal'],
      afterMeal: json['After_meal'],
      quantity: json['Quantity'],
      turnOffAfter: json['Turn_off_after'],
      notes: json['Notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "medicine_id": medicineId,
      "start_time": startTime?.format24Hour(),
      "end_time": endTime?.format24Hour(),
      "selected_times": selectedTimes
          .where((time) => time != null)
          .map((time) => time!.format24Hour())
          .toList(),
      "before_meal": beforeMeal,
      "after_meal": afterMeal,
      "notes": notes,
      // Additional fields if needed for backend
    };
  }
}

extension on TimeOfDay {
  String format24Hour() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
