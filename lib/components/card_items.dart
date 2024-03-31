import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'baby_facts_page.dart';

class CardItem {
  final String assetImage;
  final String title, summary;
  List<Color> colors = [];
  CardItem(
      {required this.assetImage,
      required this.title,
      required this.colors,
      required this.summary});
}

List<CardItem> items = [
  CardItem(
      assetImage: 'images/smilingBaby.png',
      title: "Wait for the Smiles",
      colors: [
        Colors.pink[100]!,
        Colors.pink[200]!,
        Colors.pink[300]!,
        Colors.pink[400]!,
      ],
      summary: "Before the 2-month mark you'll see a boss-face 😉"),
  CardItem(
      assetImage: 'images/bathingBaby.png',
      title: "Wait for Bath Time",
      colors: [
        Colors.blue[100]!,
        Colors.blue[200]!,
        Colors.blue[300]!,
        Colors.blue[400]!,
      ],
      summary:
          "Until your baby's umbilical cord falls off, it's sponge baths only"),
  CardItem(
      assetImage: 'images/drySkin.png',
      title: "Dry Skin is Normal",
      colors: [
        Colors.yellow[100]!,
        Colors.yellow[200]!,
        Colors.yellow[300]!,
        Colors.yellow[400]!,
      ],
      summary:
          "If you soaked yourself in liquid for nine months and then hit the air, you'd be dry too"),
  CardItem(
      assetImage: 'images/sleepingBaby.png',
      title: "Cat Naps are Real",
      colors: [
        Colors.purple[100]!,
        Colors.purple[200]!,
        Colors.purple[300]!,
        Colors.purple[400]!,
      ],
      summary:
          "During the day, don't let them snooze more than three hours without waking them to feed"),
  CardItem(
      assetImage: 'images/cryingBaby.png',
      title: "Newborns do cry a lot",
      colors: [
        Colors.lightGreen[100]!,
        Colors.lightGreen[200]!,
        Colors.lightGreen[300]!,
        Colors.lightGreen[400]!,
      ],
      summary:
          "They will let you know they're hungry, cold, have a dirty diaper, or want to be held"),
];

Widget buildCard({
  required CardItem item,
  required int index, required BuildContext context
}) =>
    Container(
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
              height: 180,
              width: 180,
              right: 105,
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
              height: 35,
              width: 100,
              top: 150,
              left: 160,
              child: ElevatedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Colors.white, width: 2)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 24, 126)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          settings: RouteSettings(name: '\fact_info'), builder: (context) => FactPage(index: index,)),
                    );
                  },
                  child: Text(
                    'Learn More',
                    style: TextStyle(fontSize: 10),
                  )),
            ),
            Positioned(
                height: 100,
                width: 105,
                top: 40,
                left: 165,
                child: Text(item.summary,
                    softWrap: true, style: TextStyle(fontFamily: 'Inria'))),
          ],
        ));
