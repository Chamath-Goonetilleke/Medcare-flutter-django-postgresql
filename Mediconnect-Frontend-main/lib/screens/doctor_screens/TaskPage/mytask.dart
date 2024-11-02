// import 'package:doctor/TaskPage/weeklyplaner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/screens/doctor_screens/TaskPage/weeklyplaner.dart';
import 'task.dart';

// Define the Task class to store task details

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<TaskPage> {
  final DateTime currentDate = DateTime.now();
  late DateTime selectedDate; // Initialize with the current date

  Map<DateTime, List<Task>> tasks = {
    // Sample tasks for demonstration
    DateTime.now(): [
      Task(
        name: 'Task 1',
        venue: 'Venue 1',
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
      ),
      Task(
        name: 'Task 2',
        venue: 'Venue 2',
        startTime: const TimeOfDay(hour: 12, minute: 0),
        endTime: const TimeOfDay(hour: 13, minute: 0),
      ),
    ],
    DateTime.now().add(const Duration(days: 1)): [
      Task(
        name: 'Task 3',
        venue: 'Venue 3',
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    selectedDate = currentDate; // Set selectedDate to the current date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Task'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                DateTime date = currentDate.add(Duration(days: index));
                String dayNumber = DateFormat('d').format(date);
                String dayName =
                    DateFormat('E').format(date); // Day name (Mon, Tue, etc.)
                bool isToday = date.day == currentDate.day &&
                    date.month == currentDate.month &&
                    date.year == currentDate.year;
                bool isSelected = selectedDate.day == date.day &&
                    selectedDate.month == date.month &&
                    selectedDate.year == date.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          dayName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (isSelected && !isToday)
                                ? Colors.green.shade100
                                : (isToday
                                    ? Colors.green.shade300
                                    : Colors.grey[300]),
                          ),
                          child: Center(
                            child: Text(
                              dayNumber,
                              style: TextStyle(
                                fontSize: 18,
                                color: (isSelected && !isToday)
                                    ? Colors.green.shade700
                                    : (isToday ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          //Today task
          if (selectedDate.day == currentDate.day &&
              selectedDate.month == currentDate.month &&
              selectedDate.year == currentDate.year)
            Container(
              padding: const EdgeInsets.only(right: 225),
              child: const Text(
                "Today's Task",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: tasks[selectedDate]?.length ?? 0,
                itemBuilder: (context, index) {
                  Task task = tasks[selectedDate]![index];
                  return Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 0, top: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 205, 216, 235),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              task.venue,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${task.startTime.format(context)} to ${task.endTime.format(context)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 90,
                        ),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: task.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  task.isCompleted = !task.isCompleted;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                _editTaskDialog(context, task);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddTaskDialog(context);
              if (kDebugMode) {
                print("Add Task button clicked");
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.lightBlue.shade100,
            ),
            child: const Text(
              "Add task",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeekPlanner()),
              );
              if (kDebugMode) {
                print("Weekly planner button clicked");
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.lightBlue.shade100,
            ),
            child: const Text(
              "Week planner",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  void _editTaskDialog(BuildContext context, Task task) {
    String taskName = task.name;
    String venue = task.venue;
    TimeOfDay startTime = task.startTime;
    TimeOfDay endTime = task.endTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter task name'),
                  controller: TextEditingController(text: taskName),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter venue'),
                  controller: TextEditingController(text: venue),
                  onChanged: (value) {
                    venue = value;
                  },
                ),
                TextButton(
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (selectedTime != null) {
                      startTime = selectedTime;
                    }
                  },
                  child: const Text('Select Start Time'),
                ),
                TextButton(
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (selectedTime != null) {
                      endTime = selectedTime;
                    }
                  },
                  child: const Text('Select End Time'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskName.isNotEmpty &&
                    venue.isNotEmpty &&
                    !_isTimeOverlap(startTime, endTime)) {
                  setState(() {
                    task.name = taskName;
                    task.venue = venue;
                    task.startTime = startTime;
                    task.endTime = endTime;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Task time overlaps with an existing task')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String taskName = '';
    String venue = '';
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter task name'),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter venue'),
                  onChanged: (value) {
                    venue = value;
                  },
                ),
                TextButton(
                  onPressed: () async {
                    startTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: const Text('Select Start Time'),
                ),
                TextButton(
                  onPressed: () async {
                    endTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: const Text('Select End Time'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskName.isNotEmpty &&
                    venue.isNotEmpty &&
                    startTime != null &&
                    endTime != null &&
                    !_isTimeOverlap(startTime!, endTime!)) {
                  setState(() {
                    tasks.putIfAbsent(selectedDate, () => []).add(Task(
                          name: taskName,
                          venue: venue,
                          startTime: startTime!,
                          endTime: endTime!,
                        ));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Task time overlaps with an existing task')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Helper function to check for time overlap
  bool _isTimeOverlap(TimeOfDay newStartTime, TimeOfDay newEndTime) {
    if (tasks[selectedDate] != null) {
      for (Task task in tasks[selectedDate]!) {
        final existingStart = task.startTime;
        final existingEnd = task.endTime;

        final newStart = _timeOfDayToDouble(newStartTime);
        final newEnd = _timeOfDayToDouble(newEndTime);
        final existingStartDouble = _timeOfDayToDouble(existingStart);
        final existingEndDouble = _timeOfDayToDouble(existingEnd);

        if (!(newEnd <= existingStartDouble || newStart >= existingEndDouble)) {
          return true;
        }
      }
    }
    return false;
  }

  // Convert TimeOfDay to double for easy comparison
  double _timeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }
}
