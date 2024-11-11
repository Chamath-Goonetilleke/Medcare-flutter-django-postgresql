// buildToggleField(
//                       'Interval',
//                       enabled: intervalEnabled,
//                       onChanged: (value) {
//                         setState(() {
//                           intervalEnabled = value;
//                           if (intervalEnabled) {
//                             timesPerDayEnabled =
//                                 false; // Disable Times per Day if Interval is enabled
//                           }
//                         });
//                       },
//                       child: intervalEnabled
//                           ? Row(
//                               children: [
//                                 DropdownButton<int>(
//                                   value: intervalHours,
//                                   items: List.generate(
//                                       12,
//                                       (index) => DropdownMenuItem(
//                                             value: index + 1,
//                                             child: Text('${index + 1} hours'),
//                                           )),
//                                   onChanged: (value) {
//                                     setState(() => intervalHours = value!);
//                                   },
//                                 ),
//                               ],
//                             )
//                           : null,
//                     ),
//                     buildToggleField(
//                       'Times per Day',
//                       enabled: timesPerDayEnabled,
//                       onChanged: (value) {
//                         setState(() {
//                           timesPerDayEnabled = value;
//                           if (timesPerDayEnabled) {
//                             intervalEnabled =
//                                 false; // Disable Interval if Times per Day is enabled
//                           }
//                         });
//                       },
//                       child: timesPerDayEnabled
//                           ? Row(
//                               children: [
//                                 DropdownButton<int>(
//                                   value: timesPerDay,
//                                   items: List.generate(
//                                       10,
//                                       (index) => DropdownMenuItem(
//                                             value: index + 1,
//                                             child: Text('${index + 1} times'),
//                                           )),
//                                   onChanged: (value) {
//                                     setState(() => timesPerDay = value!);
//                                   },
//                                 ),
//                               ],
//                             )
//                           : null,
//                     ),
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetInstructionsScaffold extends StatefulWidget {
  final Map<String, dynamic> medication;
  final Map<String, dynamic> instructions;

  const SetInstructionsScaffold({
    Key? key,
    required this.medication,
    required this.instructions,
  }) : super(key: key);

  @override
  _SetInstructionsScaffoldState createState() =>
      _SetInstructionsScaffoldState();
}

class _SetInstructionsScaffoldState extends State<SetInstructionsScaffold> {
  bool isLoading = true;
  bool intervalEnabled = false;
  bool timesPerDayEnabled = false;
  bool daysOfWeekEnabled = false;
  bool mealTimingEnabled = false;
  bool quantityEnabled = false;
  bool turnOffEnabled = false;

  int intervalHours = 6;
  int timesPerDay = 3;
  bool beforeMeal = false;
  bool afterMeal = false;
  int quantity = 2;
  int turnOffWeeks = 2;
  String additionalInstructions = '';
  late TextEditingController additionalInstructionsController;

  Map<String, bool> selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeFields();
    additionalInstructionsController =
        TextEditingController(text: additionalInstructions);
    additionalInstructionsController.addListener(() {
      setState(() {
        additionalInstructions = additionalInstructionsController.text;
      });
    });
  }

  @override
  void dispose() {
    additionalInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _initializeFields() async {
    final uri = Uri.parse(
        "http://13.60.21.117:8000/api/pharmacy/${widget.medication['id']}");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      final instructions = data['data'];
      setState(() {
        intervalEnabled = instructions['Interval'] != null;
        intervalHours = intervalEnabled
            ? int.tryParse(instructions['Interval'].split(' ')[0]) ?? 6
            : 6;
        timesPerDayEnabled = instructions['Times_per_day'] != null;
        timesPerDay = timesPerDayEnabled ? instructions['Times_per_day'] : 3;
        daysOfWeekEnabled = instructions.keys.any((day) =>
            day == 'Monday' ||
            day == 'Tuesday' ||
            day == 'Wednesday' ||
            day == 'Thursday' ||
            day == 'Friday' ||
            day == 'Saturday' ||
            day == 'Sunday');
        if (daysOfWeekEnabled) {
          selectedDays.forEach((day, _) {
            selectedDays[day] = instructions[day] ?? false;
          });
        }
        mealTimingEnabled = instructions['Before_meal'] != null ||
            instructions['After_meal'] != null;
        beforeMeal = instructions['Before_meal'] ?? false;
        afterMeal = instructions['After_meal'] ?? false;
        quantityEnabled = instructions['Quantity'] != null;
        quantity = quantityEnabled
            ? int.tryParse(instructions['Quantity'].split(' ')[0]) ?? 2
            : 2;
        turnOffEnabled = instructions['Turn_off_after'] != null;
        turnOffWeeks = turnOffEnabled
            ? int.tryParse(instructions['Turn_off_after'].split(' ')[0]) ?? 2
            : 2;
        additionalInstructions = instructions['Notes'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveInstructions() async {
    final url = Uri.parse('http://13.60.21.117:8000/api/pharmacy/');
    final requestData = {
      "Medicine_ID": widget.medication['id'],
      "Interval": intervalEnabled ? '$intervalHours hours' : null,
      "Times_per_day": timesPerDayEnabled ? timesPerDay : null,
      "Monday": selectedDays['Monday'],
      "Tuesday": selectedDays['Tuesday'],
      "Wednesday": selectedDays['Wednesday'],
      "Thursday": selectedDays['Thursday'],
      "Friday": selectedDays['Friday'],
      "Saturday": selectedDays['Saturday'],
      "Sunday": selectedDays['Sunday'],
      "Before_meal": mealTimingEnabled ? beforeMeal : false,
      "After_meal": mealTimingEnabled ? afterMeal : false,
      "Quantity": quantityEnabled ? '$quantity pills' : null,
      "Turn_off_after": turnOffEnabled ? '$turnOffWeeks weeks' : null,
      "Notes": additionalInstructions,
    };
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Success'),
            content: Text('Instructions saved successfully!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content:
                Text('Failed to save instructions: ${errorData["message"]}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Network Error'),
          content: Text('Unable to contact server. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication['text']),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    buildToggleField(
                      'Interval',
                      enabled: intervalEnabled,
                      onChanged: (value) {
                        setState(() {
                          intervalEnabled = value;
                          if (intervalEnabled) timesPerDayEnabled = false;
                        });
                      },
                      child: intervalEnabled
                          ? Row(
                              children: [
                                DropdownButton<int>(
                                  value: intervalHours,
                                  items: List.generate(
                                      12,
                                      (index) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text('${index + 1} hours'),
                                          )),
                                  onChanged: (value) {
                                    setState(() => intervalHours = value!);
                                  },
                                ),
                              ],
                            )
                          : null,
                    ),
                    buildToggleField(
                      'Times per Day',
                      enabled: timesPerDayEnabled,
                      onChanged: (value) {
                        setState(() {
                          timesPerDayEnabled = value;
                          if (timesPerDayEnabled) intervalEnabled = false;
                        });
                      },
                      child: timesPerDayEnabled
                          ? Row(
                              children: [
                                DropdownButton<int>(
                                  value: timesPerDay,
                                  items: List.generate(
                                      10,
                                      (index) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text('${index + 1} times'),
                                          )),
                                  onChanged: (value) {
                                    setState(() => timesPerDay = value!);
                                  },
                                ),
                              ],
                            )
                          : null,
                    ),
                    buildToggleField(
                      'Specified Days of the Week',
                      enabled: daysOfWeekEnabled,
                      onChanged: (value) {
                        setState(() => daysOfWeekEnabled = value);
                      },
                      child: daysOfWeekEnabled
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: selectedDays.keys.map((day) {
                                return Column(
                                  children: [
                                    Text(day.substring(0, 3)),
                                    Checkbox(
                                      value: selectedDays[day],
                                      onChanged: (value) {
                                        setState(
                                            () => selectedDays[day] = value!);
                                      },
                                    ),
                                  ],
                                );
                              }).toList(),
                            )
                          : null,
                    ),
                    buildToggleField(
                      'Select Meal Timing',
                      enabled: mealTimingEnabled,
                      onChanged: (value) {
                        setState(() => mealTimingEnabled = value);
                      },
                      child: mealTimingEnabled
                          ? Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => setState(() {
                                      beforeMeal = true;
                                      afterMeal = false;
                                    }),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: beforeMeal
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    child: const Text('Before Meal'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => setState(() {
                                      afterMeal = true;
                                      beforeMeal = false;
                                    }),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: afterMeal
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    child: const Text('After Meal'),
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                    buildToggleField(
                      'Select Quantity',
                      enabled: quantityEnabled,
                      onChanged: (value) {
                        setState(() => quantityEnabled = value);
                      },
                      child: quantityEnabled
                          ? DropdownButton<int>(
                              value: quantity,
                              items: List.generate(
                                  10,
                                  (index) => DropdownMenuItem(
                                        value: index + 1,
                                        child: Text('${index + 1} pills'),
                                      )),
                              onChanged: (value) {
                                setState(() => quantity = value!);
                              },
                            )
                          : null,
                    ),
                    buildToggleField(
                      'Turn Off Medication After',
                      enabled: turnOffEnabled,
                      onChanged: (value) {
                        setState(() => turnOffEnabled = value);
                      },
                      child: turnOffEnabled
                          ? DropdownButton<int>(
                              value: turnOffWeeks,
                              items: List.generate(
                                  10,
                                  (index) => DropdownMenuItem(
                                        value: index + 1,
                                        child: Text('${index + 1} weeks'),
                                      )),
                              onChanged: (value) {
                                setState(() => turnOffWeeks = value!);
                              },
                            )
                          : null,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Additional Instructions',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      controller: additionalInstructionsController,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: saveInstructions,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 40),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          "Save Instructions",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildToggleField(String label,
      {required bool enabled,
      required ValueChanged<bool> onChanged,
      Widget? child}) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(label),
          value: enabled,
          onChanged: onChanged,
        ),
        if (enabled && child != null) child,
      ],
    );
  }
}
