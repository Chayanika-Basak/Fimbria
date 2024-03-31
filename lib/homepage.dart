import 'dart:core';
import 'package:flutter/cupertino.dart';
// import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'components/primary_appbar.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        child: PrimaryAppBar(
          page: 'homepage',
        ),
        preferredSize: const Size.fromHeight(60.0),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [],
      )),
    );
  }
}

// Your GridCard widget function
class GridCard extends StatelessWidget {
  final String image;
  final String text;
  final String name;
  final page;

  GridCard(
      {required this.image,
      required this.text,
      required this.name,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
              settings: RouteSettings(name: name), builder: (context) => page),
        )
      },
      child: Card(
        child: Column(
          children: [
            Image.asset(
              image,
              fit: BoxFit.contain,
              width: 100, // Adjust as needed
              height: 100, // Adjust as needed
            ),
            // SizedBox(height: 8.0),
            Container(
              height: 40,
              child: Text(
                text,
                style: TextStyle(fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
