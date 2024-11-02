import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TodayTaskContainer extends StatefulWidget {
  // Correct spelling and naming convention
  final bool confirmButtonStatus;

  const TodayTaskContainer({super.key, this.confirmButtonStatus = true});

  @override
  State<TodayTaskContainer> createState() => _TodayTaskContainerState();
}

class _TodayTaskContainerState extends State<TodayTaskContainer> {
  bool confirmStatus = false;
  String time = '16:30';
  String venue = 'maharagama';

  void _onConfirm() {
    if (kDebugMode) {
      print("Clicked confirm button");
    }
    if (widget.confirmButtonStatus) {
      setState(() {
        confirmStatus = true;
      });
      if (kDebugMode) {
        print(widget.confirmButtonStatus);
      }
      showConfirmMessage(context); // Show confirmation message
    }
  }

  void showConfirmMessage(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Successfully Added'),
      duration: Duration(seconds: 2),
    );

    // Display the snackbar using the ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return (!confirmStatus)
        ? Container(
            width: double.infinity,
            height: 150,
            color: const Color.fromARGB(255, 207, 205, 205),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: const Text('T0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12))),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 200, // Adjust width as needed
                      height: 30,
                      child: DropdownButtonFormField<String>(
                        padding: const EdgeInsets.only(left: 2),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 15,
                        ),
                        value: venue,
                        items: const [
                          DropdownMenuItem(
                            value: 'maharagama',
                            child: Text('maharagama',
                                style: TextStyle(fontSize: 10)),
                          ),
                          DropdownMenuItem(
                            value: 'kalupovila',
                            child: Text('kalupovila',
                                style: TextStyle(fontSize: 10)),
                          ),
                        ],
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: const Text('AT',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12))),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 200, // Adjust width as needed
                      height: 30,
                      child: DropdownButtonFormField<String>(
                        padding: const EdgeInsets.only(left: 2),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 15,
                        ),
                        value: time,
                        items: const [
                          DropdownMenuItem(
                            value: '16:30',
                            child:
                                Text('4.30pm', style: TextStyle(fontSize: 10)),
                          ),
                          DropdownMenuItem(
                            value: '12:00',
                            child:
                                Text('12:00pm', style: TextStyle(fontSize: 10)),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            time = value!;
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _onConfirm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 25),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70),
                          ),
                          backgroundColor: Colors.blue.shade100,
                        ),
                        child: const Text(
                          "Confirm Pre-planned",
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ),
                    ),
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
