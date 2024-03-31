import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/chartGradient.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class ppd_graph extends StatefulWidget {
  const ppd_graph({super.key});

  @override
  State<ppd_graph> createState() => _ppd_graphState();
}

class _ppd_graphState extends State<ppd_graph> {
  StreamController? _streamController;
  Stream? _stream;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Timer? _debounce;
  List<PPDValues> columnData = [];

  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController!.stream;
    fillColumnData();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void fillColumnData() async {
    _streamController!.add("Loading...");
    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    CollectionReference ppdRef = FirebaseFirestore.instance.collection('PPD');
    var checkups = userSnap['ppd_checkups'];
    for (var docID in checkups) {
      var ppdSnap = await ppdRef.doc(docID).get();
      Timestamp checkup_timestamp = ppdSnap['date'];
      String checkup_date = checkup_timestamp.toDate().toString();
      print(checkup_date);
      // if (checkup_date.substring(3, 6) == "Jun") {
      //   checkup_date = "${checkup_date}e";
      // }
      int score = ppdSnap['sum'];
      columnData.add(PPDValues(checkup_date, score));
    }
    // chartTitle = "PPD Graph";
    _streamController!.add(columnData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(110.0),
      //   child: PrimaryAppBar(
      //     page: 'homepage',
      //   ),
      // ),
      body: ListView(
        children: [
          //By Day
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
            child: const Text(
              'PPD Scores Over Time',
              style: TextStyle(
                fontFamily: 'Inria',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          StreamBuilder(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Column(
                      children: [
                        Text("Empty"),
                        SizedBox(height: 300),
                      ],
                    ),
                  );
                }

                if (snapshot.data == "Loading...") {
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 300),
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  // if (data["list"].length == 0) {
                  //   return const Text('Type a nearby place');
                  // }
                  print("Before column data");
                  // graphData = [...columnData];
                  // clearColumnData();
                  print("After column data");
                  return Container(
                    child: SfCartesianChart(
                      title: ChartTitle(text: "PPD Chart"),
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                      ),
                      series: [
                        AreaSeries<PPDValues, String>(
                            dataSource: data,
                            xValueMapper: (PPDValues data, _) => data.date,
                            yValueMapper: (PPDValues data, _) => data.score,
                            gradient: linearGradient,
                            borderColor: Colors.black26,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(fontSize: 20),
                                borderColor: Colors.black54)),
                      ],
                      // enableAxisAnimation: true,
                      margin: const EdgeInsets.all(6),
                    ),
                  );
                }
                return Container();
              }),
              
        ],
      ),
    );
  }
}

class PPDValues {
  String? date;
  int score;

  PPDValues(this.date, this.score);
}
