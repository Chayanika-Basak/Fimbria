import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'poopHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:uuid/uuid.dart';

class Diaper_Main extends StatefulWidget {
  const Diaper_Main({Key? key}) : super(key: key);

  @override
  State<Diaper_Main> createState() => _DiaperState();
}

class _DiaperState extends State<Diaper_Main> {
  int count = 0;
  int? _sliding = 0;
  int? _sliding1 = 0;
  int? _sliding2 = 0;

  String _content = 'Pee';
  String _color = 'Yellow';
  String _consistency = 'Sticky';

  String userid() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return uid;
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController contentEditingController =
          TextEditingController(),
      notesEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Baby's Diaper",
            style: TextStyle(fontFamily: 'Inria')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    child: Text(
                      'Content Of Diaper',
                      style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                    ),
                    padding: EdgeInsets.all(10)),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: CupertinoSlidingSegmentedControl(
                      padding: EdgeInsets.all(10),
                      children: const {
                        0: Text(
                          'Pee',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        1: Text(
                          'Poop',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        2: Text(
                          'Mixed',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        3: Text(
                          'Dry',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                      },
                      groupValue: _sliding1,
                      onValueChanged: (int? newValue) {
                        setState(() {
                          _sliding1 = newValue;

                          if (_sliding1 == 0) {
                            _content = 'Pee';
                          } else {
                            if (_sliding1 == 1) {
                              _content = 'Poop';
                            } else {
                              if (_sliding1 == 2) {
                                _content = 'Mixed';
                              } else {
                                if (_sliding1 == 3) {
                                  _content = 'Dry';
                                }
                              }
                            }
                          }

                          print(_content);
                        });
                      },
                      backgroundColor: Colors.pink[200]!),
                ),
                Container(
                    child: Text(
                      'Color of Content',
                      style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                    ),
                    padding: EdgeInsets.all(10)),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: CupertinoSlidingSegmentedControl(
                      padding: EdgeInsets.all(10),
                      children: const {
                        0: Text(
                          'Yellow',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        1: Text(
                          'Brown',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        2: Text(
                          'Black',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        3: Text(
                          'Green',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                      },
                      groupValue: _sliding,
                      onValueChanged: (int? newValue) {
                        setState(() {
                          _sliding = newValue;
                          if (_sliding == 0) {
                            _color = 'Yellow';
                          } else {
                            if (_sliding == 1) {
                              _color = 'Brown';
                            } else {
                              if (_sliding == 2) {
                                _color = 'Black';
                              } else {
                                if (_sliding == 3) {
                                  _color = 'Green';
                                }
                              }
                            }
                          }

                          print(_color);
                        });
                      },
                      backgroundColor: Colors.pink[200]!),
                ),
                Container(
                    child: Text(
                      'Consistency',
                      style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                    ),
                    padding: EdgeInsets.all(10)),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: CupertinoSlidingSegmentedControl(
                      padding: EdgeInsets.all(10),
                      children: const {
                        0: Text(
                          'Sticky',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        1: Text(
                          'Mushy',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        2: Text(
                          'Soft',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                        3: Text(
                          'Well Formed',
                          style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                        ),
                      },
                      groupValue: _sliding2,
                      onValueChanged: (int? newValue) {
                        setState(() {
                          _sliding2 = newValue;
                          if (_sliding2 == 0) {
                            _consistency = 'Sticky';
                          } else {
                            if (_sliding2 == 1) {
                              _consistency = 'Mushy';
                            } else {
                              if (_sliding2 == 2) {
                                _consistency = 'Soft';
                              } else {
                                if (_sliding2 == 3) {
                                  _consistency = 'Well Formed';
                                }
                              }
                            }
                          }

                          print(_consistency);
                        });
                      },
                      backgroundColor: Colors.pink[200]!),
                ),
                Container(
                    child: Text(
                      'Notes',
                      style: TextStyle(fontSize: 15, fontFamily: 'Inria'),
                    ),
                    padding: EdgeInsets.all(10)),
                Container(
                  height: 170,
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
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.center,
                  child: CupertinoButton(
                    alignment: Alignment.center,
                    onPressed: () async {
                      print(userid());
                      var date = DateTime.now();
                      String Date = "${date.day}-${date.month}-${date.year}";
                      String time =
                          "${date.hour}.${date.minute}.${date.second}";
                      String diaperID = const Uuid().v1();
                      await _firestore
                          .collection('users')
                          .doc(userid())
                          .collection('diaper')
                          .doc(diaperID)
                          .set({
                        'date': Date,
                        'time': time,
                        'content': _content,
                        'color': _color,
                        'consistency': _consistency,
                        'notes': notesEditingController.text!
                      }).then((value) {
                        notesEditingController.clear();
                        setState(() {
                          _sliding = 0;
                          _sliding1 = 0;
                          _sliding2= 0;
                        });
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
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: CupertinoButton(
                    alignment: Alignment.center,
                    child: Text(
                      'History',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Inria'),
                    ),
                    color: Colors.pink[300],
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            settings: RouteSettings(name: 'poopHistory'),
                            builder: (context) => DiaperHistoryScreen(
                                  uid: uid,
                                )),
                      );
                    },
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
