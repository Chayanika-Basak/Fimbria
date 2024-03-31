import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'report.dart';

import '../components/general_button.dart';
import '../components/primary_appbar.dart';

class Submission extends StatefulWidget {
  String image, question, opt1, opt2, opt3, opt4;
  List<int> answers;
  Submission(
      {Key? key,
      required this.image,
      required this.question,
      required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      required this.answers})
      : super(key: key);

  @override
  State<Submission> createState() => _SubmissionState(
      image: image,
      question: question,
      opt1: opt1,
      opt2: opt2,
      opt3: opt3,
      opt4: opt4,
      answers: answers);
}

class _SubmissionState extends State<Submission> {
  GlobalKey<FormState> key = GlobalKey();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? docID;
  String image, question, opt1, opt2, opt3, opt4;
  List<int> answers;
  int ans = 0, sum = 0;
  String? response1, response2, response3, response4;
  Color? color1, color2, color3, color4;

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  _SubmissionState(
      {required this.image,
      required this.question,
      required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      required this.answers});
  CollectionReference user = FirebaseFirestore.instance.collection('PPD');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    color1 = Colors.pink[100];
    color2 = color3 = color4 = Colors.transparent;
    response1 = response2 = response3 = response4 = 'error';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: PrimaryAppBar(
          page: 'ppd',
        ),
        preferredSize: const Size.fromHeight(110.0),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(7),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  // decoration: BoxDecoration(
                  //     color: Colors.pink[300],
                  //     borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Please choose the option that best suits you:",
                    style: TextStyle(
                      fontFamily: 'Inria',
                      fontSize: 15,
                    ),
                  )),
              Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Inria',
                                fontSize: 20,
                                color: Colors.white),
                            softWrap: true,
                          ),
                        ),
                        Container(
                          child: Image.asset(image),
                          width: 150,
                          height: 200,
                        ),
                      ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ans = 0;
                        color1 = Colors.pink[100];
                        color2 = Colors.transparent;
                        color3 = Colors.transparent;
                        color4 = Colors.transparent;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black38),
                            borderRadius: BorderRadius.circular(20),
                            color: color1),
                        child: Text(
                          opt1,
                          style: TextStyle(fontFamily: 'Inria', fontSize: 15),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ans = 1;
                        color1 = Colors.transparent;
                        color2 = Colors.pink[100];
                        color3 = Colors.transparent;
                        color4 = Colors.transparent;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black38),
                            borderRadius: BorderRadius.circular(20),
                            color: color2),
                        child: Text(
                          opt2,
                          style: TextStyle(fontFamily: 'Inria', fontSize: 15),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ans = 2;
                        color1 = Colors.transparent;
                        color2 = Colors.transparent;
                        color3 = Colors.pink[100];
                        color4 = Colors.transparent;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black38),
                            borderRadius: BorderRadius.circular(20),
                            color: color3),
                        child: Text(
                          opt3,
                          style: TextStyle(fontFamily: 'Inria', fontSize: 15),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ans = 3;
                        color1 = Colors.transparent;
                        color2 = Colors.transparent;
                        color3 = Colors.transparent;
                        color4 = Colors.pink[100];
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black38),
                            borderRadius: BorderRadius.circular(20),
                            color: color4),
                        child: Text(
                          opt4,
                          style: TextStyle(fontFamily: 'Inria', fontSize: 15),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 15),
              GeneralButton(
                onPressed: () async {
                  // Calculating EPDS Score
                  setState(() {
                    answers[9] = ans;
                    for (var element in answers) {
                      sum += element;
                    }
                  });

                  // Getting Current User Profile
                  var userSnap = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get();

                  // Calling Gemini API
                  gemini
                      .generateFromText(
                          "What is Edinburgh Postnatal Depression Scale Score? What symptoms does this Edinburgh Postnatal Depression Scale Score of ${sum} imply about me? What precautions should I take if my Edinburgh Postnatal Depression Scale Score is ${sum}? Suggest any doctor consultancy required for my Edinburgh Postnatal Depression Scale Score of ${sum}? Answer these questions in points under the subheadings 'What is EPDS', 'Symptoms', 'Precautions' and 'Doctor Consultancy' respectively.")
                      .then((value) async {
                    // Update response
                    setState(() {
                      response1 = value.text
                          .replaceAll('*', '')
                          .split("What is EPDS:")[1].split("Symptoms:")[0];
                      response2 =
                          value.text.replaceAll('*', '').split("Symptoms:")[1].split("Precautions:")[0];
                      response3 = value.text
                          .replaceAll('*', '')
                          .split("Precautions:")[1].split("Doctor Consultancy:")[0];
                      response4 = value.text
                          .replaceAll('*', '')
                          .split("Doctor Consultancy:")[1];
                    });

                    // Add in FireStore
                    await user.add({
                      'uid': uid,
                      'username': userSnap['name'],
                      'answers': answers,
                      'sum': sum,
                      'date': DateTime.now(),
                      'response1': response1,
                      'response2': response2,
                      'response3': response3,
                      'response4': response4
                    }).then((DocumentReference doc) => {
                          // Get doc id from firestore
                          setState(() {
                            docID = doc.id;
                          })
                        });

                    // Update User Profile
                    await _firestore.collection('users').doc(uid).update({
                      'ppd_checkups': FieldValue.arrayUnion([docID])
                    });

                    // print()

                    // Navigate to report
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          settings: RouteSettings(name: "/ppd_report"),
                          builder: (context) => Report(
                                score: sum,
                                response1: response1!,
                                response2: response2!,
                                response3: response3!,
                                response4: response4!,
                              )),
                    );

                    // Handle Error
                  }).onError((error, stackTrace) async {
                    // Update response
                    setState(() {
                      response1 = response2 = response3 = response4 = "error";
                    });

                    // Navigate to report page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          settings: RouteSettings(name: "/ppd_report"),
                          builder: (context) => Report(
                                score: sum,
                                response1: response1!,
                                response2: response2!,
                                response3: response3!,
                                response4: response4!,
                              )),
                    );
                  });
                },
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inria',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
