import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/general_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../submission.dart';
import 'questionaire.dart';
import '../../components/primary_appbar.dart';

class PPD_Form extends StatefulWidget {
  String image, question, opt1, opt2, opt3, opt4;
  int ind;
  bool isLast;
  List<int> answers;
  PPD_Form(
      {Key? key,
      required this.image,
      required this.question,
      required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      required this.isLast,
      required this.ind,
      required this.answers})
      : super(key: key);

  @override
  State<PPD_Form> createState() => _PPD_FormState(
      image: image,
      question: question,
      opt1: opt1,
      opt2: opt2,
      opt3: opt3,
      opt4: opt4,
      isLast: isLast,
      ind: ind,
      answers: answers);
}

enum userType { user, organization }

class _PPD_FormState extends State<PPD_Form> {
  final _formKey = GlobalKey<FormState>();
  int ans = 0;
  String image, question, opt1, opt2, opt3, opt4;
  bool isLast;
  int ind;
  List<int> answers;
  Color? color1, color2, color3, color4;

  _PPD_FormState(
      {required this.image,
      required this.question,
      required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      required this.isLast,
      required this.ind,
      required this.answers});

  @override
  void initState() {
    super.initState();
    color1 = Colors.pink[100];
    color2 = color3 = color4 = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: PrimaryAppBar(
            page: 'ppd',
          ),
          preferredSize: const Size.fromHeight(90.0),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black38),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black38),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black38),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black38),
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
                Container(
                  width: 300,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GeneralButton(
                          onPressed: () async {
                            setState(() {
                              answers[ind] = ans;
                            });
                            isLast
                                ? Navigator.of(context).push(
                                    MaterialPageRoute(
                                        settings: RouteSettings(
                                            name: "/ppd_submission"),
                                        builder: (context) => Submission(
                                            image: PPD_images[8],
                                            question: questions[8],
                                            opt1: option1[8],
                                            opt2: option2[8],
                                            opt3: option3[8],
                                            opt4: option4[8],
                                            answers: answers)),
                                  )
                                : Navigator.of(context).push(
                                    MaterialPageRoute(
                                        settings: RouteSettings(
                                            name: "/ppd_page${ind}"),
                                        builder: (context) => PPD_Form(
                                              image: PPD_images[ind],
                                              question: questions[ind],
                                              opt1: option1[ind],
                                              opt2: option2[ind],
                                              opt3: option3[ind],
                                              opt4: option4[ind],
                                              isLast: ind == 7 ? true : false,
                                              ind: ind + 1,
                                              answers: answers,
                                            )),
                                  );
                          },
                          child: const Text(
                            'NEXT',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inria',
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}
