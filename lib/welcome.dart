import 'dart:core';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.pink[100]!,
            Colors.pink[200]!,
            Colors.pink[300]!,
            Colors.pink[400]!,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
      
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 25,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text('Fimbria',
                          textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 50,
                                fontFamily: 'Inria',
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[900],
                              )),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/mother.png'),
                          fit: BoxFit.contain,
                          alignment: Alignment.center
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 25,),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Image.asset(
                        //   'images/birds.png',
                        // ),
                        
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TextButton.icon(
                            icon: Icon(Icons.login),
                            style: TextButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 255, 24, 126),
                              backgroundColor: Colors.white60,
                              side: BorderSide(color: Colors.white, width: 2),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                              minimumSize: Size(150, 50),
                              elevation: 200,
                            ),
                            onPressed: () =>
                                {Navigator.pushNamed(context, 'login')},
                            label: const Text('Login'),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TextButton.icon(
                            icon: Icon(Icons.assignment_ind),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              //backgroundColor: Color.fromARGB(255, 20, 42, 30),
                              backgroundColor: Color.fromARGB(255, 255, 24, 126),
                              side: BorderSide(color: Colors.white60, width: 2),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: Size(150, 50),
                              elevation: 200,
                            ),
                            onPressed: () =>
                                {Navigator.pushNamed(context, 'signup')},
                            label: const Text('Sign Up'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
