import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BreastfeedingHistoryScreen extends StatefulWidget {
  final uid;
  const BreastfeedingHistoryScreen({Key? key, required this.uid})
      : super(key: key);

  @override
  _BreastfeedingHistoryScreenState createState() =>
      _BreastfeedingHistoryScreenState();
}

class _BreastfeedingHistoryScreenState
    extends State<BreastfeedingHistoryScreen> {
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
          'Breastfeeding History',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('breastfeeding')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('loading....'),
            );
          }
          return
              // Text('OK');
              ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => HistoryCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final snap;
  const HistoryCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Data');
    print(snap.data());
    return Card(
        color: Colors.pink[50],
        shadowColor: Colors.pink[400],
        margin: EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Date: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                Text(
                  '${snap.data()['date']}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Time: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                Text(
                  '${snap.data()['time']}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Icon(
                      Icons.water_drop,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Left Side: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                Text(
                  '${snap.data()['left']} seconds',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Icon(
                      Icons.water_drop,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Right Side: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                Text(
                  '${snap.data()['right']} seconds',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          snap.data()['color'] != null && snap.data()['color'] != ""
              ? Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Color: ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ]),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${snap.data()['color']}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Container(),
          snap.data()['notes'] != null && snap.data()['notes'] != ""
              ? Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Notes: ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ]),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          '${snap.data()['notes']}',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ]));
  }
}
