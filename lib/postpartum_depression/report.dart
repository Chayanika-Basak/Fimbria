import 'package:flutter/material.dart';
import 'main.dart';

import '../components/general_button.dart';

const apiKey = "AIzaSyAc8VNOA2zxAJkFsIcAnqdA3gjevglUz8Q";

class Report extends StatelessWidget {
  String response1, response2, response3, response4;
  int score;
  Report(
      {super.key,
      required this.score,
      required this.response1,
      required this.response2,
      required this.response3,
      required this.response4});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(240, 98, 146, 1)),
        useMaterial3: true,
      ),
      home: MyReport(
          score: score,
          response1: response1,
          response2: response2,
          response3: response3,
          response4: response4),
    );
  }
}

class MyReport extends StatefulWidget {
  String response1, response2, response3, response4;
  int score;
  MyReport(
      {super.key,
      required this.score,
      required this.response1,
      required this.response2,
      required this.response3,
      required this.response4});

  @override
  State<MyReport> createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Here's what we think! 👩🏻‍⚕️"),
        centerTitle: true,
      ),
      body: TextOnly(
          score: widget.score,
          response1: widget.response1,
          response2: widget.response2,
          response3: widget.response3,
          response4: widget.response4),
    );
  }
}

// ------------------------------ Text Only ------------------------------

class TextOnly extends StatefulWidget {
  String response1, response2, response3, response4;
  int score;

  TextOnly(
      {super.key,
      required this.score,
      required this.response1,
      required this.response2,
      required this.response3,
      required this.response4});

  @override
  State<TextOnly> createState() => _TextOnlyState();
}

class _TextOnlyState extends State<TextOnly> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Your EPDS Score is ${widget.score}',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "What is EPDS:",
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 16, color: Colors.white),
              )),
          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(widget.response1,
                  style: TextStyle(fontFamily: 'Inria', fontSize: 15))),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Symptoms:",
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 16, color: Colors.white),
              )),
          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(widget.response2,
                  style: TextStyle(fontFamily: 'Inria', fontSize: 15))),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Precautions:",
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 16, color: Colors.white),
              )),
          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                widget.response3,
                style: TextStyle(fontFamily: 'Inria', fontSize: 16),
              )),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Doctor Consultancy:",
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 16, color: Colors.white),
              )),
          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(widget.response4,
                  style: TextStyle(fontFamily: 'Inria', fontSize: 16))),
          GeneralButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      settings: RouteSettings(name: "/ppd"),
                      builder: (context) => PPDMain()),
                );
              },
              child: Text(
                "Back Home",
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 20, color: Colors.white),
              )),
          SizedBox(height: 15),
        ],
      ),
    ));
  }
}

// fromText(query: _textController.text)
