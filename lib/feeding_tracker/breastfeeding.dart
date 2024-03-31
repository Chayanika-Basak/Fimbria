import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'history/breastfeedingHistory.dart';
import 'package:uuid/uuid.dart';

class Breastfeeding extends StatefulWidget {
  String uid;
  Breastfeeding({super.key, required this.uid});
  @override
  State<Breastfeeding> createState() => _BreastfeedingState();
}

class _BreastfeedingState extends State<Breastfeeding> {
  late Stopwatch leftStopwatch, rightStopwatch;
  late Timer left_t, right_t;
  String leftButtonText = "Start", rightButtonText = "Start";
  final TextEditingController contentEditingController =
          TextEditingController(),
      notesEditingController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void handleLeftStartStop() {
    if (leftStopwatch.isRunning) {
      leftStopwatch.stop();
      setState(() {
        leftButtonText = "Start";
      });
    } else {
      leftStopwatch.start();
      setState(() {
        leftButtonText = "Stop";
      });
    }
  }

  void handleRightStartStop() {
    if (rightStopwatch.isRunning) {
      rightStopwatch.stop();
      setState(() {
        rightButtonText = "Start";
      });
    } else {
      rightStopwatch.start();
      setState(() {
        rightButtonText = "Stop";
      });
    }
  }

  String returnLeftFormattedText() {
    var milli = leftStopwatch.elapsed.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, "0");
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }

  String returnRightFormattedText() {
    var milli = rightStopwatch.elapsed.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, "0");
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    leftStopwatch = Stopwatch();
    rightStopwatch = Stopwatch();

    left_t = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });

    right_t = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              children: [
                Text("Left Side",
                    style: TextStyle(fontFamily: 'Inria', fontSize: 20)),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.pink[300]!,
                      width: 4,
                    ),
                  ),
                  child: Text(
                    returnLeftFormattedText(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CupertinoButton(
                  onPressed: () {
                    handleLeftStartStop();
                  },
                  padding: EdgeInsets.all(0),
                  child: Text(
                    leftButtonText,
                    style: TextStyle(
                      color: Colors.pink[300]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    leftStopwatch.reset();
                  },
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: Colors.pink[300]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("Right Side",
                    style: TextStyle(fontFamily: 'Inria', fontSize: 20)),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.pink[300]!,
                      width: 4,
                    ),
                  ),
                  child: Text(
                    returnRightFormattedText(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CupertinoButton(
                  onPressed: () {
                    handleRightStartStop();
                  },
                  padding: EdgeInsets.all(0),
                  child: Text(
                    rightButtonText,
                    style: TextStyle(
                      color: Colors.pink[300]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    rightStopwatch.reset();
                  },
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: Colors.pink[300]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
          SizedBox(height: 20),
          Divider(
            color: Colors.pink[300],
          ),
          SizedBox(height: 20),
          Container(
              alignment: Alignment.center,
              child: Text('Milk Color',
                  style: TextStyle(fontFamily: 'Inria', fontSize: 22))),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.pink[300]!, width: 2),
                borderRadius: BorderRadius.circular(25)),
            child: TextField(
              controller: contentEditingController,
              decoration: InputDecoration(
                  hintText: 'Milk, Water, Chocolate Milk...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontFamily: 'Inria')),
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: Text('Notes',
                  style: TextStyle(fontFamily: 'Inria', fontSize: 22))),
          Container(
            height: 170,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.pink[300]!, width: 2),
                borderRadius: BorderRadius.circular(25)),
            child: TextField(
              controller: notesEditingController,
              decoration: InputDecoration(
                  hintText: 'Got something to jot down?',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontFamily: 'Inria')),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: CupertinoButton(
              alignment: Alignment.center,
              onPressed: () async {
                // print(uid);
                var date = DateTime.now();
                String Date = "${date.day}-${date.month}-${date.year}";
                String time = "${date.hour}.${date.minute}.${date.second}";
                String bfID = const Uuid().v1();
                await _firestore
                    .collection('users')
                    .doc(widget.uid)
                    .collection('breastfeeding')
                    .doc(bfID)
                    .set({
                  'date': Date,
                  'time': time,
                  'left': leftStopwatch.elapsed.inSeconds,
                  'right': rightStopwatch.elapsed.inSeconds,
                  'color': contentEditingController.text!,
                  'notes': notesEditingController.text!
                }).then((value) {
                  leftStopwatch.reset();
                  rightStopwatch.reset();
                  contentEditingController.clear();
                  notesEditingController.clear();
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.pink[300],
              borderRadius: BorderRadius.circular(10),
              child: Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inria'),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: CupertinoButton(
              alignment: Alignment.center,
              child: Text(
                'History',
                style: TextStyle(color: Colors.white, fontFamily: 'Inria'),
              ),
              color: Colors.pink[300],
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      settings: RouteSettings(name: '\history'),
                      builder: (context) => BreastfeedingHistoryScreen(
                            uid: widget.uid,
                          )),
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    ));
  }
}
