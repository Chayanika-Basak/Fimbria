import 'package:flutter/material.dart';
import '../components/general_button.dart';
import 'excercise_data.dart';

import 'pose_detector_view.dart';

class Instructions extends StatefulWidget {
  int index;
  Instructions({super.key, required this.index});

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            dataList[widget.index]['text'],
            style: TextStyle(fontFamily: 'Inria'),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.redAccent[700]),
                  child: Text(
                      "Caution: Please always have a supervisor near you while doing these exercises",
                      style: TextStyle(
                          fontFamily: 'Inria',
                          fontSize: 13,
                          color: Colors.white))),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.yellow[700]),
                  child: Text(
                      "Your left side will be shown as yellow on camera.",
                      style: TextStyle(
                          fontFamily: 'Inria',
                          fontSize: 13,
                          color: Colors.white))),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue[700]),
                  child: Text(
                      "Your right side will be shown as blue on camera.",
                      style: TextStyle(
                          fontFamily: 'Inria',
                          fontSize: 13,
                          color: Colors.white))),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54),
                  child: Text(
                      "Always keep your camera in portrait mode.",
                      style: TextStyle(
                          fontFamily: 'Inria',
                          fontSize: 13,
                          color: Colors.white))),
              Divider(thickness: 1, color: Colors.pink[300]),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.pink[300]),
                  child: Text("Instructions",
                      style: TextStyle(
                          fontFamily: 'Inria',
                          fontSize: 18,
                          color: Colors.white))),
              Row(
                children: [
                  Container(
                      child: Image.asset(dataList[widget.index]['image'],
                          width: MediaQuery.of(context).size.width / 3,
                          fit: BoxFit.contain)),
                  Container(
                      width: MediaQuery.of(context).size.width/1.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent),
                      child: Text(
                        dataList[widget.index]['line1'],
                        style: TextStyle(
                            fontFamily: 'Inria',
                            fontSize: 16,
                            color: Colors.black),
                        softWrap: true,
                      )),
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent),
                  child: Text(dataList[widget.index]['line2'],
                      style: TextStyle(
                          fontFamily: 'Inria',
                          fontSize: 16))),
              GeneralButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          settings: RouteSettings(name: "/pose_est"),
                          builder: (context) => PoseDetectorView(
                              excercise: dataList[widget.index]['text'].toLowerCase())),
                    );
                  },
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                        fontFamily: 'Inria', fontSize: 15, color: Colors.white),
                  ))
            ])));
  }
}
