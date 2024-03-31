import 'package:flutter/material.dart';
import 'instruction.dart';

import 'excercise_data.dart';

class Pose_Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Excercises for You',
          style: TextStyle(fontFamily: 'Inria'),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: dataList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
          ),
          itemBuilder: (BuildContext context, int index) {
            // Pass each element of the list to the Tile widget
            return Tile(
              index: index
            );
          },
        ),
      ),
    );
  }
}

// Your Tile widget function
class Tile extends StatelessWidget {
  final int index;

  Tile({required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
              settings: RouteSettings(name: "/instruction"),
              builder: (context) => Instructions(index: index)),
        )
      },
      child: Card(
        child: Stack(
          children: [
            Positioned(
              top: 25,
              child: Image.asset(
                dataList[index]['image'],
                fit: BoxFit.contain,
                width: 150, // Adjust as needed
                height: 150, // Adjust as needed
              ),
            ),
            SizedBox(height: 8.0),
            Positioned(
              left: 10,
              width: 130,
              child: Text(
                dataList[index]['text'],
                style: TextStyle(fontSize: 16.0, fontFamily: 'Inria'),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
