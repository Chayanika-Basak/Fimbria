import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/post_card.dart';

class FeedScreen extends StatefulWidget {
  String collection;
  FeedScreen({Key? key, required this.collection}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> following = [];

  getData() async {
    print('Going to firestore....');
    var data = await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print('Got data...');
    setState(() {
      following = data["following"];
    });
    print(following);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print(
              "Following is: ${following} and length is: ${following.length}");
          return following.length == 0
              ? Center(
                child: Container(
                    child: Text('Follow people to fill your feed...',
                        style: TextStyle(fontFamily: 'Inria', fontSize: 15))),
              )
              : Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => following.contains(
                            snapshot.data!.docs[index].data()["uid"] as dynamic)
                        ? Container(
                            child: PostCard(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          )
                        : Container(),
                  ),
                );
        },
      ),
    );
  }
}
