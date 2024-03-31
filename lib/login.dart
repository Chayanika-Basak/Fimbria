import 'dart:core';
import 'package:flutter/material.dart';
import '/services/authFunctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// enum userType { user, organization }

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullname = '';
  bool login = true;
  // userType? type = userType.user;
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
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/login.png',
                      height: 200,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ======== Full Name ========
                            login
                                ? Container()
                                : TextFormField(
                                    key: ValueKey('fullname'),
                                    decoration: InputDecoration(
                                      hintText: 'Enter Full Name',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Full Name';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        fullname = value!;
                                      });
                                    },
                                  ),

                            // ======== Email ========
                            TextFormField(
                              key: ValueKey('email'),
                              decoration: InputDecoration(
                                hintText: 'Enter Email',
                              ),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please Enter valid Email';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                setState(() {
                                  email = value!;
                                });
                              },
                            ),
                            // ======== Password ========
                            TextFormField(
                              key: ValueKey('password'),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                              ),
                              validator: (value) {
                                if (value!.length < 6) {
                                  return 'Please Enter Password of min length 6';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                setState(() {
                                  password = value!;
                                });
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 55,
                              width: 200,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white, width: 2)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  255, 255, 24, 126)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white)),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      if (login) {
                                        bool loggedin =
                                            await AuthServices.signinUser(
                                                email, password, context);
                                        if (loggedin)
                                          Navigator.pushNamed(
                                              context, 'homepage');
                                      } else {
                                        AuthServices.signupUser(
                                            email, password, fullname, context);

                                        login = !login;
                                      }
                                    }
                                  },
                                  child: Text(login ? 'Login' : 'Signup')),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  login = !login;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      login
                                          ? "Don't have an account? "
                                          : "Already have an account? ",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Inria',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white70,
                                      )),
                                  Text(login ? "Signup " : "Login ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Inria',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.pink[900],
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
