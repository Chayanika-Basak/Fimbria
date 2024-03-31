// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:gsc2024/postpartum_depression/graph.dart';
// import 'package:unixtime/unixtime.dart';

// String chartTitle = "";


// List<PPDValues> columnData = [];
// void fillColumnData() async {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String uid = FirebaseAuth.instance.currentUser!.uid;
//   var userSnap =
//       await FirebaseFirestore.instance.collection('users').doc(uid).get();
//   CollectionReference ppdRef = FirebaseFirestore.instance.collection('PPD');
//   var checkups = userSnap['ppd_checkups'];
//   for (var docID in checkups) {
//     var ppdSnap =
//         await FirebaseFirestore.instance.collection('PPD').doc(docID).get();
//     String checkup_date = ppdSnap['date'].substring(0, 6);
//     if (checkup_date.substring(3, 6) == "Jun") {
//       checkup_date = "${checkup_date}e";
//     }
//     int score = ppdSnap['sum'];
//     columnData.add(PPDValues(checkup_date,score));;
//   }
//   chartTitle = "PPD Graph";
// }

// void clearColumnData() {
//   columnData.clear();
// }
