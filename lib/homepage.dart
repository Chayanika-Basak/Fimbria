import 'dart:core';
import 'package:fimbria/appointment_tracker/appointment_main.dart';
import 'package:fimbria/diaperTracker/poopDetails.dart';
import 'package:fimbria/feeding_tracker/feeding_main.dart';
import 'package:fimbria/gynae_near_me/gynae_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'components/card_items.dart';
import 'components/feature_cards.dart';
import 'components/primary_appbar.dart';
import 'connect/connect.dart';
import 'pose_estimation/pose_main.dart';
import 'postpartum_depression/chatbot.dart';
import 'postpartum_depression/main.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  late List<Map<String, dynamic>> dataList = [
    {
      "image": "images/ppd.png",
      "text": "Postpartum Depression Screening",
      "name": '/ppd',
      "page": PPDMain()
    },
    {
      "image": "images/excercise.png",
      "text": "Excercise",
      "name": '/pose_est',
      "page": Pose_Main()
    },
    {
      "image": "images/breastfeeding.png",
      "text": "Feeding Tracker",
      "name": '/feed',
      "page": Feeding_Main()
    },
    {
      "image": "images/doctor.png",
      "text": "Track Appointment",
      "name": '/doctor',
      "page": Appointment_Main()
    },
    {
      "image": "images/diaper.png",
      "text": "Track Diapers",
      "name": '/diaper',
      "page": Diaper_Main()
    },
    {
      "image": "images/gynae.png",
      "text": "Gynae Near Me",
      "name": '/gynae',
      "page": GynaeMain()
    },
    {
      "image": "images/holdBaby.png",
      "text": "Lets Relate",
      "name": '/hold',
      "page": Connect(collection: 'users',)
    },
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.pink[300],
          shape: BoxShape.circle
        ),
        child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      settings: RouteSettings(name: "/chatbot"),
                      builder: (context) => ChatBot()),
                );
              },
              child: Icon(
                Icons.chat,
                color: Colors.white,
                size: 40,
              )),
      ),
      appBar: PreferredSize(
        child: PrimaryAppBar(
          page: 'homepage',
        ),
        preferredSize: const Size.fromHeight(60.0),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Text('Let Us Help You',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria',
                      color: Colors.black))),
          Container(
            height: 206,
            child: CarouselSlider.builder(
              itemCount: feature_items.length,
              itemBuilder: (context, index, realIndex) {
                return buildFeatureCard(context, item: feature_items[index]);
              },
              options: CarouselOptions(
                height: size.height,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {},
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: size.width / 2.2,
                        child: GridCard(
                            image: dataList[0]['image'],
                            text: dataList[0]['text'],
                            name: dataList[0]['name'],
                            page: dataList[0]['page']),
                      ),
                      Container(
                        width: size.width / 2.2,
                        child: GridCard(
                            image: dataList[1]['image'],
                            text: dataList[1]['text'],
                            name: dataList[1]['name'],
                            page: dataList[1]['page']),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: size.width / 2.2,
                        child: GridCard(
                            image: dataList[2]['image'],
                            text: dataList[2]['text'],
                            name: dataList[2]['name'],
                            page: dataList[2]['page']),
                      ),
                      Container(
                        width: size.width / 2.2,
                        child: GridCard(
                            image: dataList[3]['image'],
                            text: dataList[3]['text'],
                            name: dataList[3]['name'],
                            page: dataList[3]['page']),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: size.width / 2.2,
                        child: GridCard(
                            image: dataList[4]['image'],
                            text: dataList[4]['text'],
                            name: dataList[4]['name'],
                            page: dataList[4]['page']),
                      ),
                      Container(
                        width: size.width / 2.2,
                        child: GridCard(
                            image: dataList[5]['image'],
                            text: dataList[5]['text'],
                            name: dataList[5]['name'],
                            page: dataList[5]['page']),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: size.width / 2.2,
                        child: GridCard(
                            image: dataList[6]['image'],
                            text: dataList[6]['text'],
                            name: dataList[6]['name'],
                            page: dataList[6]['page']),
                      ),
                    ],
                  )
                ],
              )),
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Text('Facts About Babies',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria',
                      color: Colors.black))),
          Container(
            height: 206,
            child: CarouselSlider.builder(
              itemCount: items.length,
              itemBuilder: (context, index, realIndex) {
                return buildCard(
                    item: items[index], index: index, context: context);
              },
              options: CarouselOptions(
                height: size.height,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {},
              ),
            ),
          ),
        ],
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
