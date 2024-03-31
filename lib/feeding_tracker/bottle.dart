import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'history/bottleHistory.dart';
import 'package:uuid/uuid.dart';

class Bottle extends StatefulWidget {
  Bottle({super.key, required this.uid});
  String uid;
  @override
  State<Bottle> createState() => _BottleState(uid: uid);
}

class _BottleState extends State<Bottle> {
  late Stopwatch stopwatch;
  late Timer t;
  String buttonText = "Start";
  String uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController contentEditingController =
          TextEditingController(),
      notesEditingController = TextEditingController();

  _BottleState({required this.uid});

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      setState(() {
        buttonText = "Start";
      });
    } else {
      stopwatch.start();
      setState(() {
        buttonText = "Stop";
      });
    }
  }

  String returnFormattedText() {
    var milli = stopwatch.elapsed.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, "0");
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();

    t = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text("Feeding Duration",
                style: TextStyle(fontFamily: 'Inria', fontSize: 22)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                returnFormattedText(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(children: [
              CupertinoButton(
                onPressed: () {
                  handleStartStop();
                },
                padding: EdgeInsets.all(0),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.pink[300]!,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  stopwatch.reset();
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
            ])
          ]),
          SizedBox(height: 20),
          Divider(
            color: Colors.pink[300],
          ),
          SizedBox(height: 20),
          Container(
              alignment: Alignment.center,
              child: Text('Contents of Bottle',
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
                  hintText: 'Milk, Water...',
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
                print(uid);
                var date = DateTime.now();
                String Date = "${date.day}-${date.month}-${date.year}";
                String time = "${date.hour}.${date.minute}.${date.second}";
                String bfID = const Uuid().v1();
                await _firestore
                    .collection('users')
                    .doc(uid)
                    .collection('bottle')
                    .doc(bfID)
                    .set({
                  'date': Date,
                  'time': time,
                  'duration': stopwatch.elapsed.inSeconds,
                  'contents': contentEditingController.text!,
                  'notes': notesEditingController.text!
                }).then((value) {
                  stopwatch.reset();
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
                      builder: (context) => BottleHistoryScreen(
                            uid: uid,
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
