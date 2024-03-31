import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'facts_page_data.dart';
import 'primary_appbar.dart';

class FactPage extends StatefulWidget {
  FactPage({super.key, required this.index});
  int index;
  @override
  State<FactPage> createState() => _FactPageState();
}

class _FactPageState extends State<FactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: PrimaryAppBar(
            page: 'homepage',
          ),
          preferredSize: const Size.fromHeight(60.0),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 25),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: facts_data[widget.index]['color1'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(facts_data[widget.index]['title'],
                style: TextStyle(
                    fontFamily: 'Inria', fontSize: 24, color: Colors.white)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 22),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                facts_data[widget.index]['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: facts_data[widget.index]['color2'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              facts_data[widget.index]['text'],
              style: TextStyle(fontFamily: 'Inria', fontSize: 18),
            ),
          ),
          // margin: EdgeInsets.all(25),
          // padding: EdgeInsets.all(15),
          // decoration: BoxDecoration(
          //   color: facts_data[widget.index]['color2'],
          //   borderRadius: BorderRadius.circular(20),
          // ),
          // child:
          // ListView.builder(

          //   itemCount: facts_data.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Container(
          //       height: 50,
          //       color: Colors.pink[300],
          //       child: Center(child: Text(facts_data[widget.index]['text'])),
          //     );
          //   }
          // )
          // Text(
          //     facts_data[widget.index]['text'],

          //   style: TextStyle(
          //     fontFamily: 'Inria',
          //     fontSize: 18
          //   ),
          // ),
        ])));
  }
}
