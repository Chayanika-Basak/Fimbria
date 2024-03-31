import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'bottle.dart';
import 'breastfeeding.dart';
import 'pumping.dart';

class Feeding_Main extends StatelessWidget {
  const Feeding_Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Feeding();
  }
}

class Feeding extends StatefulWidget {
  const Feeding({super.key});

  @override
  State<Feeding> createState() => _FeedingState();
}

class _FeedingState extends State<Feeding> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Track Baby's Feeding",style: TextStyle(fontFamily: 'Inria')),
              // centerTitle: true,
              bottom: const TabBar(
                indicatorColor: Color.fromRGBO(240, 98, 146, 1),
                labelColor: Colors.black,
                tabs: [
                  Tab(child: Text("Breastfeeding",style: TextStyle(fontFamily: 'Inria', fontSize: 13))),
                  Tab(child: Text("Bottle",style: TextStyle(fontFamily: 'Inria'))),
                  Tab(child: Text("Pump",style: TextStyle(fontFamily: 'Inria'))),
                ],
              ),
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
            ),
            body: TabBarView(
              children: [
                Breastfeeding(uid: uid),
                Bottle(uid: uid),
                Pump(uid: uid)
              ],
            )),
      ),
    );
  }
}
