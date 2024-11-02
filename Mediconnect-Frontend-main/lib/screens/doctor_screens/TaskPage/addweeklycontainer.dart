// import 'package:doctor/TaskPage/sendtoserver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/screens/doctor_screens/TaskPage/sendtoserver.dart';

class PlannerContainer extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final bool Deletebuttonstatus;

  // ignore: non_constant_identifier_names
  const PlannerContainer({super.key, this.Deletebuttonstatus = true});

  @override
  State<PlannerContainer> createState() => _PlannerContainerState();
}

class _PlannerContainerState extends State<PlannerContainer> {
// Title of the task
  final _fromHourController = TextEditingController(); // Hours of "from" value
  final _fromMinuteController =
      TextEditingController(); // Minutes of "from" value
  String _fromAmPm = 'AM'; // AM/PM for "from" value
  final TextEditingController _textController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool _delstatus = true;

  //to time value

  final _toHourController = TextEditingController(); // Hours of "from" value
  final _toMinuteController =
      TextEditingController(); // Minutes of "from" value
  // ignore: prefer_final_fields
  String _toAmPm = 'AM'; // AM/PM for "from" value
  bool _statusofRepeatButton = false;
  String _repeatchoice = 'Week';
  String _repeatchoicecount = 'one';

  //set venue
  String venue = 'Nawaloga Hospital-Colombo'; // default vaenue
  // ignore: non_constant_identifier_names
  List<bool> days_status = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ]; // It is a default for selected days in that plan
  //[Mon,Tue,Wed,Thus,Fri,Sat,Sun]

////////////// select days ///////////////////////////////////
  // ignore: non_constant_identifier_names
  void _changedaystatus(int Index) {
    if (Index > 6) {
      if (kDebugMode) {
        print("Exception in Day status input ");
      }
    } else {
      setState(() {
        days_status[Index] = !days_status[Index];
      });
    }
  }
///////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////// Status of Repeat week ///////////////
  void _stausrepeat() {
    setState(() {
      _statusofRepeatButton = !_statusofRepeatButton;
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////// press Delete button ////////////////////////////////////////////
  void _resetInputs() {
    setState(() {
      _fromHourController.clear();
      _fromMinuteController.clear();
      _toHourController.clear();
      _toMinuteController.clear();
      days_status = [false, false, false, false, false, false, false];
      venue = 'Nawaloga Hospital-Colombo';
      _textController.clear();
      if (widget.Deletebuttonstatus) {
        _delstatus = !_delstatus;
      }

      // Clear other controllers if you have more input fields
    });
  }

  Future<void> _selectFromTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      // Convert 24-hour time to 12-hour format
      final hour = selectedTime.hourOfPeriod;
      final minute = selectedTime.minute;
      final amPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

      // Update controllers and state
      setState(() {
        _fromHourController.text = hour.toString().padLeft(2, '0');
        _fromMinuteController.text = minute.toString().padLeft(2, '0');
        _fromAmPm = amPm;
      });
    }
  }

  Future<void> _selecttoTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      // Convert 24-hour time to 12-hour format
      final hour = selectedTime.hourOfPeriod;
      final minute = selectedTime.minute;
      final amPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

      // Update controllers and state
      setState(() {
        _toHourController.text = hour.toString().padLeft(2, '0');
        _toMinuteController.text = minute.toString().padLeft(2, '0');
        _fromAmPm = amPm;
      });
    }
  }

  void showDeleteMessage(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Deleted'),
      duration: Duration(
          seconds:
              2), // The duration for how long the message will be displayed
    );

    // Display the snackbar using the ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showConfrimMessage(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Successfully Added'),
      duration: Duration(
          seconds:
              2), // The duration for how long the message will be displayed
    );

    // Display the snackbar using the ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailureMeaasge(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Adde Weakly task failure'),
      duration: Duration(
          seconds:
              2), // The duration for how long the message will be displayed
    );

    // Display the snackbar using the ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return (_delstatus)
        ? Container(
            width: double.infinity,
            height: 350,
            color: const Color.fromARGB(255, 207, 205, 205),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  width: 300,
                  height: 50,
                  child: TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.zero,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.zero,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.zero,
                      ),
                      labelText: 'Task Title...',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                    onSaved: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 50),
                    // alignment: Alignment.centerLeft,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0)),
                                backgroundColor: WidgetStateProperty.all(
                                    const Color.fromARGB(255, 207, 205, 205)),
                                side: const WidgetStatePropertyAll(BorderSide(
                                    width: 0, style: BorderStyle.none)),
                                elevation: const WidgetStatePropertyAll(0)),
                            onPressed: _selectFromTime,
                            child: const Text("From",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ),
                        ),
                        // Flexible(
                        //   child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: TextFormField(
                                style: const TextStyle(fontSize: 10),
                                controller: _fromHourController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  labelText: 'hrs',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2), // Reduced width
                            const Text(":"),
                            const SizedBox(width: 2), // Reduced width
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: TextFormField(
                                style: const TextStyle(fontSize: 10),
                                controller: _fromMinuteController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  labelText: 'min',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            // Reduced width
                            SizedBox(
                              width: 40, // Adjust width as needed
                              height: 30,
                              child: DropdownButtonFormField<String>(
                                padding: const EdgeInsets.only(left: 2),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 15,
                                ),
                                value: _fromAmPm,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'AM',
                                    child: Text('AM',
                                        style: TextStyle(fontSize: 8)),
                                  ),
                                  DropdownMenuItem(
                                      value: 'PM',
                                      child: Text('PM',
                                          style: TextStyle(fontSize: 8))),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _fromAmPm = value ?? 'AM';
                                  });
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                        //  ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 20,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0)),
                                backgroundColor: WidgetStateProperty.all(
                                    const Color.fromARGB(255, 207, 205, 205)),
                                side: const WidgetStatePropertyAll(BorderSide(
                                    width: 0, style: BorderStyle.none)),
                                elevation: const WidgetStatePropertyAll(0)),
                            onPressed: _selecttoTime,
                            child: const Text("to",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 10),
                                  controller: _toHourController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    labelText: 'hrs',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Text(":"),
                              const SizedBox(width: 2), // Reduced width
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 10),
                                  controller: _toMinuteController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    labelText: 'min',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2), // Reduced width
                              SizedBox(
                                width: 40, // Adjust width as needed
                                height: 30,
                                child: DropdownButtonFormField<String>(
                                  padding: const EdgeInsets.only(left: 2),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    size: 15,
                                  ),
                                  value: _toAmPm,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'AM',
                                      child: Text('AM',
                                          style: TextStyle(fontSize: 8)),
                                    ),
                                    DropdownMenuItem(
                                        value: 'PM',
                                        child: Text('PM',
                                            style: TextStyle(fontSize: 8))),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _toAmPm = value ?? 'AM';
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: const Text('AT',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12))),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 250, // Adjust width as needed
                      height: 30,
                      child: DropdownButtonFormField<String>(
                        padding: const EdgeInsets.only(left: 2),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 15,
                        ),
                        value: venue,
                        items: const [
/////////////////////////////////////////////   Add Dropdown value ///////////////////////////////////////////////////////////////////
                          DropdownMenuItem(
                            value: 'Nawaloga Hospital-Colombo',
                            child: Text('Nawaloga Hospital-Colombo',
                                style: TextStyle(fontSize: 10)),
                          ),
                          DropdownMenuItem(
                              value: 'Kalupovila Hospital',
                              child: Text('Kalupovila Hospital',
                                  style: TextStyle(fontSize: 10))),
                        ],
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        onChanged: (value) {
                          setState(() {
                            venue = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5, right: 0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("Monday button on click");
                          }
                          _changedaystatus(0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: days_status[0]
                              ? Colors.green.shade200
                              : Colors.grey,
                          // side:const BorderSide(width: 0,color:Color.fromARGB(255, 207, 205, 205) ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                              2), // Control the size of the circle
                          elevation: 5, // Add elevation
                        ),
                        child: const Text(
                          "Mon",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("Tuesday button on click");
                          }
                          _changedaystatus(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: days_status[1]
                              ? Colors.green.shade200
                              : Colors.grey,
                          // side:const BorderSide(width: 0,color:Color.fromARGB(255, 207, 205, 205) ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                              2), // Control the size of the circle
                          elevation: 5, // Add elevation
                        ),
                        child: const Text(
                          "Tue",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("Wednessday button on click");
                          }
                          _changedaystatus(2);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: days_status[2]
                              ? Colors.green.shade200
                              : Colors.grey,
                          // side:const BorderSide(width: 0,color:Color.fromARGB(255, 207, 205, 205) ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                              2), // Control the size of the circle
                          elevation: 5, // Add elevation
                        ),
                        child: const Text(
                          "Wed",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("Thusday button on click");
                          }
                          _changedaystatus(3);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: days_status[3]
                              ? Colors.green.shade200
                              : Colors.grey,
                          // side:const BorderSide(width: 0,color:Color.fromARGB(255, 207, 205, 205) ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                              2), // Control the size of the circle
                          elevation: 5, // Add elevation
                        ),
                        child: const Text(
                          "Thu",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("Friday button on click");
                          }
                          _changedaystatus(4);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: days_status[4]
                              ? Colors.green.shade200
                              : Colors.grey,
                          // side:const BorderSide(width: 0,color:Color.fromARGB(255, 207, 205, 205) ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                              2), // Control the size of the circle
                          elevation: 5, // Add elevation
                        ),
                        child: const Text(
                          "Fri",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("saturday button on click");
                          }
                          _changedaystatus(5);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: days_status[5]
                              ? Colors.green.shade200
                              : Colors.grey,
                          // side:const BorderSide(width: 0,color:Color.fromARGB(255, 207, 205, 205) ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                              2), // Control the size of the circle
                          elevation: 5, // Add elevation
                        ),
                        child: const Text(
                          "Sat",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("SunDay button on click");
                          }
                          _changedaystatus(6);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: days_status[6]
                              ? Colors.green.shade200
                              : Colors.grey,
                          // side:const BorderSide(width: 0,color:Color.fromARGB(255, 207, 205, 205) ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                              2), // Control the size of the circle
                          elevation: 5, // Add elevation
                        ),
                        child: const Text(
                          "Sun",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 180),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _statusofRepeatButton,
                            onChanged: (bool? value) {
                              _stausrepeat();
                              if (kDebugMode) {
                                print("Repeat every check box clicked");
                              }
                            },
                          ),
                          const Text('Repeat every',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                          children: (_statusofRepeatButton)
                              ? [
                                  SizedBox(
                                    width: 50, // Adjust width as needed
                                    height: 30,
                                    child: DropdownButtonFormField<String>(
                                      // padding: const EdgeInsets.only(left: 2),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 15,
                                      ),
                                      value: _repeatchoice,
                                      items: const [
                                        ///////////////////////////////////////////////// Add more repeat Choice ///////////////////////////////////////////////////////////////
                                        DropdownMenuItem(
                                          value: 'Week',
                                          child: Text('Week',
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                        DropdownMenuItem(
                                            value: 'Month',
                                            child: Text('Month',
                                                style:
                                                    TextStyle(fontSize: 10))),
                                        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _repeatchoice = value ?? 'Week';
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 0),
                                      ),
                                      alignment: Alignment.centerRight,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: 40, // Adjust width as needed
                                    height: 30,
                                    child: DropdownButtonFormField<String>(
                                      //  padding: const EdgeInsets.only(left: 10),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 15,
                                      ),
                                      value: _repeatchoicecount,
                                      items: const [
//////////////////////////////////////////////////////// add count of repeat value //////////////////////////////////////////////////////////////
                                        DropdownMenuItem(
                                          value: 'one',
                                          child: Text('1',
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                        DropdownMenuItem(
                                            value: 'two',
                                            child: Text('2',
                                                style:
                                                    TextStyle(fontSize: 10))),
                                        DropdownMenuItem(
                                          value: 'three',
                                          child: Text('3',
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                        DropdownMenuItem(
                                          value: 'four',
                                          child: Text('4',
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _repeatchoicecount = value ?? 'one';
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 0),
                                      ),
                                      alignment: Alignment.centerRight,
                                    ),
                                  ),
                                ]
                              : [
                                  const SizedBox(
                                    width: 95,
                                    height: 30,
                                  ),
                                ]),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            onPressed: () {
                              _resetInputs();
                              if (kDebugMode) {
                                print("Delete button click");
                              }
                              showDeleteMessage(context);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                            ),
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 232, 133, 126)),
                            ))),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (kDebugMode) {
                                print("Confrim button click");
                              }
                              Future<bool> status = SendData(
                                  _textController.text,
                                  _fromHourController.text,
                                  _fromMinuteController.text,
                                  _fromAmPm,
                                  _toHourController.text,
                                  _toMinuteController.text,
                                  _toAmPm,
                                  _statusofRepeatButton,
                                  _repeatchoice,
                                  _repeatchoicecount,
                                  venue,
                                  days_status);
                              if (await status) {
                                // ignore: use_build_context_synchronously
                                showConfrimMessage(context);
                                _resetInputs();
                              } else {
                                // ignore: use_build_context_synchronously
                                showFailureMeaasge(context);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                            ),
                            child: const Text(
                              "Confrim",
                              style: TextStyle(color: Colors.green),
                            ))),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }
}
