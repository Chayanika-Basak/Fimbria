import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/general_button.dart';
import 'main.dart';

class ReportHistory extends StatefulWidget {
  final ppds;
  const ReportHistory({Key? key, required this.ppds}) : super(key: key);

  @override
  _ReportHistoryState createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  @override
  Widget build(BuildContext context) {
    // final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    0.3,
                    0.75,
                    0.9
                  ],
                  colors: [
                    Color.fromRGBO(248, 187, 208, 1),
                    Color.fromRGBO(252, 172, 199, 1),
                    Color.fromRGBO(240, 98, 146, 1),
                  ]),
            ),
          ),
          title: const Text(
            'PPD Reports History',
          ),
          centerTitle: false,
        ),
        body:
            // Text('OK');
            ListView.builder(
          itemCount: widget.ppds.length,
          itemBuilder: (ctx, index) => ReportCard(
            ppd: widget.ppds[index],
          ),
        ));
  }
}

class ReportCard extends StatelessWidget {
  final ppd;
  const ReportCard({Key? key, required this.ppd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Data');
    print(ppd);
    return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Date: ${DateTime.fromMicrosecondsSinceEpoch(ppd['date'].seconds * 1000000).day} - ${DateTime.fromMicrosecondsSinceEpoch(ppd['date'].seconds * 1000000).month} - ${DateTime.fromMicrosecondsSinceEpoch(ppd['date'].seconds * 1000000).year}",
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 16, color: Colors.white),
              )),
              Container(
            margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Time: ${DateTime.fromMicrosecondsSinceEpoch(ppd['date'].seconds * 1000000).hour}.${DateTime.fromMicrosecondsSinceEpoch(ppd['date'].seconds * 1000000).minute}",
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 16, color: Colors.white),
              )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Your EPDS Score was ${ppd['sum']}',
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
              child: Text(ppd['response1'],
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
              child: Text(ppd['response2'],
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
                ppd['response3'],
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
              child: Text(ppd['response4'],
                  style: TextStyle(fontFamily: 'Inria', fontSize: 16))),
          SizedBox(height: 15),
          Divider(color: Colors.pink[300], thickness: 1),
        ],
      );
  }
}
