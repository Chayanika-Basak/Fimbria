import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'graph.dart';
import 'history.dart';
import 'components/question.dart';
import 'package:flutter/material.dart';
import '../components/primary_appbar.dart';
import '../components/general_button.dart';

class PPDMain extends StatelessWidget {
  PPDMain({Key? key}) : super(key: key);
  List<int> answers = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: PrimaryAppBar(
          page: 'ppd',
        ),
        preferredSize: const Size.fromHeight(60.0),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                "Let Me Take Care of You 💞",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inria',
                  fontSize: 22,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Image.asset("images/mother.png"),
                    width: 200,
                    height: 200,
                  ), //Column
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    GeneralButton(
                      child: Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: 'Inria',
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: RouteSettings(name: "/ppd_form"),
                            builder: (context) => PPD_Form(
                              image: "images/laughingWoman.png",
                              question:
                                  "I have been able to laugh and see the funny side of things:",
                              opt1: 'As much as I always could',
                              opt2: 'Not quite so much now',
                              opt3: 'Definitely not so much now',
                              opt4: 'Not at all',
                              isLast: false,
                              ind: 0,
                              answers: answers,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    GeneralButton(
                      child: Text(
                        'History',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: 'Inria',
                        ),
                      ),
                      onPressed: () async {
                        var userSnap = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .get();
                        List<dynamic> ppds = [];
                        for (var ppdid in userSnap['ppd_checkups']) {
                          var ppdSnap = await FirebaseFirestore.instance
                              .collection('PPD')
                              .doc(ppdid)
                              .get();
                          ppds.add(ppdSnap);
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              settings: RouteSettings(name: "/report_history"),
                              builder: (context) => ReportHistory(ppds: ppds)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ), //Center

            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                "Start by telling me how you feel... ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Inria',
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ppd_graph()),
          ]),
        ),
      ),
    );
  }
}
