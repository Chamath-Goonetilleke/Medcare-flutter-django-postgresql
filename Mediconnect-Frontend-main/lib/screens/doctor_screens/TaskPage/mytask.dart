// task_page.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/screens/doctor_screens/TaskPage/weeklyplaner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<TaskPage> {
  final DateTime currentDate = DateTime.now();
  late DateTime selectedDate;
  int? docId;

  Map<DateTime, List<Task>> tasks = {};

  @override
  void initState() {
    super.initState();
    selectedDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    _fetchTasks(); // Fetch tasks from the backend
  }

  // Fetch tasks from the backend
  void _fetchTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    final uri =
        Uri.parse("http://13.60.21.117:8000/api/doctors/getByUserId/$userId");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if(data["status"] == "success"){
      setState(() {
        docId = data['data']['Doctor_ID'];
      });
      final response =
          await http.get(Uri.parse('http://13.60.21.117:8000/api/tasks/getByDoc/${data['data']['Doctor_ID']}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tasks = {};

          for (var taskData in data['data']) {
            // Normalize the date to only the date component
            DateTime date = DateTime.parse(taskData['date']).toLocal();
            DateTime onlyDate = DateTime(date.year, date.month, date.day);
            print(taskData['id']);
            Task task = Task(
              id: taskData['id'],
              name: taskData['name'],
              venue: taskData['venue'],
              startTime: TimeOfDay(
                  hour: int.parse(taskData['start_time'].split(':')[0]),
                  minute: int.parse(taskData['start_time'].split(':')[1])),
              endTime: TimeOfDay(
                  hour: int.parse(taskData['end_time'].split(':')[0]),
                  minute: int.parse(taskData['end_time'].split(':')[1])),
              isCompleted: taskData['is_completed'],
            );

            tasks.putIfAbsent(onlyDate, () => []).add(task);
          }
        });
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch tasks')),
        );
      }
    }

  }

  // Update task on the backend
  Future<void> _updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('http://13.60.21.117:8000/api/tasks/${task.id}/update/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': task.name,
        'venue': task.venue,
        'start_time': '${task.startTime.hour}:${task.startTime.minute}',
        'end_time': '${task.endTime.hour}:${task.endTime.minute}',
        'date': DateFormat('yyyy-MM-dd').format(selectedDate),
        'is_completed': task.isCompleted,
      }),
    );

    if (response.statusCode == 200) {
      // Optionally, you can parse and update the task with server response
      final updatedTask = Task.fromJson(jsonDecode(response.body)['data']);
      setState(() {
        final taskList = tasks[selectedDate];
        if (taskList != null) {
          int index = taskList.indexWhere((t) => t.id == task.id);
          if (index != -1) {
            taskList[index] = updatedTask;
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    } else {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Task'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                DateTime date = DateTime(
                        currentDate.year, currentDate.month, currentDate.day)
                    .add(Duration(days: index));
                String dayNumber = DateFormat('d').format(date);
                String dayName = DateFormat('E').format(date);
                bool isToday = date.day == currentDate.day &&
                    date.month == currentDate.month &&
                    date.year == currentDate.year;
                bool isSelected = selectedDate == date;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime(date.year, date.month, date.day);
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
                          width: 40,
                          height: 40,
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

          // Today's Task
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

          // Task List
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
                        Expanded(
                          child: Column(
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
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: task.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                                size: 30,
                              ),
                              onPressed: () async {
                                // Toggle the completion status
                                setState(() {
                                  task.isCompleted = !task.isCompleted;
                                });
                                await _updateTask(task);
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

          // Add Task Button
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

          // Week Planner Button
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

  // Edit Task Dialog
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
                // Task Name
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter task name'),
                  controller: TextEditingController(text: taskName),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                // Venue
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter venue'),
                  controller: TextEditingController(text: venue),
                  onChanged: (value) {
                    venue = value;
                  },
                ),
                // Start Time
                TextButton(
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (selectedTime != null) {
                      setState(() {
                        startTime = selectedTime;
                      });
                    }
                  },
                  child:
                      Text('Select Start Time: ${startTime.format(context)}'),
                ),
                // End Time
                TextButton(
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (selectedTime != null) {
                      setState(() {
                        endTime = selectedTime;
                      });
                    }
                  },
                  child: Text('Select End Time: ${endTime.format(context)}'),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            // Save Button
            TextButton(
              onPressed: () async {
                if (taskName.isNotEmpty &&
                    venue.isNotEmpty &&
                    !_isTimeOverlap(startTime, endTime, task.id)) {
                  // Update the task object
                  task.name = taskName;
                  task.venue = venue;
                  task.startTime = startTime;
                  task.endTime = endTime;

                  // Update the task on the backend
                  await _updateTask(task);

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Task time overlaps with an existing task or fields are empty')),
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

  // Show Add Task Dialog
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
                // Task Name
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter task name'),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                // Venue
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter venue'),
                  onChanged: (value) {
                    venue = value;
                  },
                ),
                // Start Time
                TextButton(
                  onPressed: () async {
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selected != null) {
                      setState(() {
                        startTime = selected;
                      });
                    }
                  },
                  child: Text(startTime == null
                      ? 'Select Start Time'
                      : 'Start Time: ${startTime!.format(context)}'),
                ),
                // End Time
                TextButton(
                  onPressed: () async {
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selected != null) {
                      setState(() {
                        endTime = selected;
                      });
                    }
                  },
                  child: Text(endTime == null
                      ? 'Select End Time'
                      : 'End Time: ${endTime!.format(context)}'),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            // Add Button
            TextButton(
              onPressed: () async {
                if (taskName.isNotEmpty &&
                    venue.isNotEmpty &&
                    startTime != null &&
                    endTime != null &&
                    !_isTimeOverlap(startTime!, endTime!)) {
                  final response = await http.post(
                    Uri.parse('http://13.60.21.117:8000/api/tasks/create/'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'name': taskName,
                      'venue': venue,
                      'start_time': '${startTime!.hour}:${startTime!.minute}',
                      'end_time': '${endTime!.hour}:${endTime!.minute}',
                      'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                      'doctor_id': docId
                    }),
                  );

                  if (response.statusCode == 201) {
                    _fetchTasks();
                    Navigator.of(context).pop();
                  } else {
                    // Handle errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add task')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Task time overlaps with an existing task or fields are empty')),
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
  bool _isTimeOverlap(TimeOfDay newStartTime, TimeOfDay newEndTime,
      [int? currentTaskId]) {
    if (tasks[selectedDate] != null) {
      for (Task task in tasks[selectedDate]!) {
        if (currentTaskId != null && task.id == currentTaskId) {
          continue; // Skip the current task being edited
        }
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
