// import 'package:doctor/TaskPage/addweeklycontainer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/screens/doctor_screens/TaskPage/addweeklycontainer.dart';

class WeekTask extends StatefulWidget {
  const WeekTask({super.key});

  @override
  State<WeekTask> createState() => _WeekTaskState();
}

class _WeekTaskState extends State<WeekTask> {
  // List to keep track of PlannerContainer widgets
  // ignore: prefer_final_fields
  List<Widget> _plannerContainers = [];

  void _addPlannerContainer() {
    setState(() {
      _plannerContainers.add(const PlannerContainer());
      _plannerContainers.add(const SizedBox(
        height: 20,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display existing PlannerContainer widgets
        ..._plannerContainers,
        // Button to add new PlannerContainer widgets
        Container(
          padding: const EdgeInsets.only(left: 20),
          width: 300,
          child: ElevatedButton(
            onPressed: () {
              if (kDebugMode) {
                print("Add new Weekly Task button click");
              }

              _addPlannerContainer();
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Colors.lightBlue.shade100),
            ),
            child: const Text(
              "Add New Task",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
