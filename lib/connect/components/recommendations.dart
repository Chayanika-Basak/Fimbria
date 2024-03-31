import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/profile.dart';
import '../../components/primary_appbar.dart';

class Recommendations extends StatefulWidget {
  const Recommendations({super.key});

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "RECOMMENDATIONS",
                style: TextStyle(
                  fontFamily: 'Inria',
                  fontSize: 22,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    // return ListView.builder(
                    //   itemCount: snapshot.data?.docs!.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     if (snapshot.data?.docs[index].data()['uid'] == uid)
                    //       return Container();
                    //     return buildCard(
                    //       profileImage: "https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg",
                    //           // snapshot.data?.docs[index].data()['photourl'],
                    //       username: snapshot.data?.docs[index].data()['name'],
                    //       followers: snapshot.data?.docs![index].data()['followers'].length,
                    //       color: Color.fromARGB(0, 218, 242, 206),
                    //       borderColor: Color.fromARGB(255, 51, 51, 50),
                    //       onPressed: () {
                    //         Navigator.of(context).pushReplacement(
                    //           MaterialPageRoute(
                    //               builder: (context) => Profile(
                    //                   uid: snapshot.data?.docs[index]
                    //                       .data()['uid'],
                    //                   collection: 'users')),
                    //         );
                    //       },
                    //     );
                    //   },
                    // );

                    return CarouselSlider(
                        items: (snapshot.data! as dynamic)
                            .docs
                            .map<Widget>((item) => (item['uid'] != uid) ? buildCard(
                                  profileImage: item['photourl'],
                                  username: item['name'],
                                  followers: item['followers'].length,
                                  color: Color.fromARGB(0, 218, 242, 206),
                                  borderColor:
                                      Color.fromARGB(255, 51, 51, 50),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Profile(
                                              uid: item['uid'],
                                              collection: 'users')),
                                    );
                                  },
                                ) : Container())
                            .toList(),
                        options: CarouselOptions(
                          aspectRatio: 16 / 10,
                          viewportFraction: 0.5,
                        ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
