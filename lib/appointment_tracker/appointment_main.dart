import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'baby.dart';
import 'mother.dart';

class Appointment_Main extends StatelessWidget {
  const Appointment_Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Appointment();
  }
}

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Track Your Appointments", style: TextStyle(fontFamily: 'Inria'),),
            centerTitle: true,
            leading: BackButton(onPressed: () => {Navigator.of(context).pop()}),
            bottom: const TabBar(
              indicatorColor: Color.fromRGBO(240, 98, 146, 1),
              labelColor: Colors.black,
              tabs: [
                Tab(child: Text("For You",style: TextStyle(fontFamily: 'Inria'))),
                Tab(child: Text("For Baby",style: TextStyle(fontFamily: 'Inria'))),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Mother(uid: uid),
              Baby(uid: uid)
            ],
          )),
    );
  }
}
