import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimbria/providers/user_provider.dart';
import 'package:fimbria/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'login.dart';
import 'signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.microphone.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  String uid = '';
  String collection = 'users';

  setCollection() async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (documentSnapshot.data() == null) {
      collection = 'organizations';
    } else {
      collection = 'users';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fimbria',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              uid = FirebaseAuth.instance.currentUser!.uid;
              setCollection();
              return Home();
            } else {
              //return Splash(duration: 5);
              return WelcomeScreen();
            }
          },
        ),
        routes: {
          'login': (context) => const LoginPage(),
          'signup': (context) => const SignupPage(),
          'welcomescreen': (context) => const WelcomeScreen(),
        },
      ),
    );
  }
}
