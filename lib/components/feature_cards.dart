import 'package:fimbria/feeding_tracker/feeding_main.dart';
import 'package:fimbria/gynae_near_me/gynae_main.dart';
import 'package:flutter/material.dart';

import '../connect/connect.dart';
import '../pose_estimation/pose_main.dart';
import '../postpartum_depression/main.dart';

class CardItem {
  final String assetImage;
  final String title, summary;
  List<Color> colors = [];
  final name, page;
  CardItem({
    required this.assetImage,
    required this.title,
    required this.colors,
    required this.summary,
    required this.name,
    required this.page,
  });
}

List<CardItem> feature_items = [
  CardItem(
      assetImage: 'images/ppd.png',
      title: "How do you feel today",
      colors: [
        Colors.pink[100]!,
        Colors.pink[200]!,
        Colors.pink[300]!,
        Colors.pink[400]!,
      ],
      summary: "Postpartum Depression is a serious condition. Screen for it",
      name: '/ppd',
      page: PPDMain()),
  CardItem(
      assetImage: 'images/excercise.png',
      title: "Strengthen your Pelvic Floor",
      colors: [
        Colors.blue[100]!,
        Colors.blue[200]!,
        Colors.blue[300]!,
        Colors.blue[400]!,
      ],
      summary: "Start excercising to make your delivery easier.",
      name: "/pose_est",
      page: Pose_Main()),
  CardItem(
      assetImage: 'images/breastfeeding.png',
      title: "Track Baby's Feeding Cycle",
      colors: [
        Colors.yellow[100]!,
        Colors.yellow[200]!,
        Colors.yellow[300]!,
        Colors.yellow[400]!,
      ],
      summary: "Track how much and when your baby fed and from which side.",
      name: "/feed",
      page: Feeding_Main()),
  CardItem(
      assetImage: 'images/doctor.png',
      title: "Keep Track of Appointments",
      colors: [
        Colors.purple[100]!,
        Colors.purple[200]!,
        Colors.purple[300]!,
        Colors.purple[400]!,
      ],
      summary:
          "Keep track of appointment dates, prescriptions and lab reports.",
      name: "/doctor",
      page: PPDMain()),
  CardItem(
      assetImage: 'images/diaper.png',
      title: "Track Diaper Changes",
      colors: [
        Colors.lightGreen[100]!,
        Colors.lightGreen[200]!,
        Colors.lightGreen[300]!,
        Colors.lightGreen[400]!,
      ],
      summary: "Avoid panics over last diaper change and their contents",
      name: "/diaper",
      page: PPDMain()),
  CardItem(
      assetImage: 'images/gynae.png',
      title: "Get Gynaecologists Near You",
      colors: [
        Colors.teal[100]!,
        Colors.teal[200]!,
        Colors.teal[300]!,
        Colors.teal[400]!,
      ],
      summary: "Quickly find gynecologists nearby your area",
      name: "/gynae",
      page: GynaeMain(),
      ),
      CardItem(
      assetImage: 'images/holdBaby.png',
      title: "Relate with fellow mothers",
      colors: [
        const Color.fromARGB(255, 84, 228, 247)!,
        Colors.cyan[200]!,
        Colors.cyan[300]!,
        Colors.cyan[400]!,
      ],
      summary: "Discuss about your journey of motherhood and connect with fellow mothers.",
      name: "/relate",
      page: Connect(collection: 'users',))
];

Widget buildFeatureCard(
  BuildContext context, {
  required CardItem item,
}) =>
    GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              settings: RouteSettings(name: item.name),
              builder: (context) => item.page),
        );
      },
      child: Container(
          width: 500,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black)],
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: item.colors,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                height: 200,
                width: 200,
                right: 95,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        item.assetImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: const Color.fromARGB(112, 0, 0, 0),
                ),
                child: Text(
                  item.title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria',
                      color: Colors.white),
                  softWrap: true,
                ),
              ),
              Positioned(
                  height: 130,
                  width: 105,
                  top: 40,
                  left: 165,
                  child: Text(item.summary,
                      softWrap: true, style: TextStyle(fontFamily: 'Inria'))),
            ],
          )),
    );
