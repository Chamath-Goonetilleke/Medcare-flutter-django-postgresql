import 'package:flutter/material.dart';

class Task {
  final int id;
  String name;
  String venue;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.venue,
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      venue: json['venue'],
      startTime: TimeOfDay(
        hour: int.parse(json['start_time'].split(':')[0]),
        minute: int.parse(json['start_time'].split(':')[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(json['end_time'].split(':')[0]),
        minute: int.parse(json['end_time'].split(':')[1]),
      ),
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'venue': venue,
        'start_time': '${startTime.hour}:${startTime.minute}',
        'end_time': '${endTime.hour}:${endTime.minute}',
        'date':
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}', // Adjust as needed
        'is_completed': isCompleted,
      };
}
