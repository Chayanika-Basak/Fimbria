import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login.dart';
import '../services/firestore_methods.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/utils.dart';
import '../services/storage_methods.dart';
import '../services/authFunctions.dart';
import 'add_post.dart';
import 'general_button.dart';
import 'primary_appbar.dart';

class Profile extends StatefulWidget {
  final String uid;
  final String collection;
  Function? callback;
  Profile(
      {Key? key, required this.uid, required this.collection, this.callback})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? desc;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  int petitions = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String imageUrl =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png';
  bool imageUploaded = false;
  bool enabledField = false;
  late Uint8List file;
  final TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      print('Userid: ${widget.uid}');
      print('Collection: ${widget.collection}');
      var userSnap = await FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(widget.uid)
          .get();

      // get post lENGTH
      // var postSnap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .where('uid', isEqualTo: widget.uid)
      //     .get();

      // var petitionSnap = await FirebaseFirestore.instance
      //     .collection('Petition')
      //     .where('uid', isEqualTo: widget.uid)
      //     .get();
      // petitions = petitionSnap.docs.length;
      // postLen = postSnap.docs.length;
      print("Error in next line");
      userData = userSnap.data()!;
      print("Userdata for uid=${widget.uid} = ${userData}");
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      desc = widget.collection == "users"
          ? userSnap.data()!['bio']
          : userSnap.data()!['mission'];
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        imageUrl = userSnap.data()!['photourl'];
        if (imageUrl.isNotEmpty) imageUploaded = true;
      });
    } catch (e) {
      showSnackBar(
        context,
        "The Error in Profile is: $e",
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  selectImage() async {
    file = await pickImage(ImageSource.gallery);
    String photoUrl =
        await StorageMethods().uploadImageToStorage('profilePics', file, false);
    setState(() {
      imageUrl = photoUrl;
      imageUploaded = true;
    });
    await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(widget.uid)
        .update({'photourl': photoUrl});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: PrimaryAppBar(
                page: 'homepage',
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(110.0),
              child: PrimaryAppBar(
                page: 'homepage',
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(imageUrl),
                            radius: 40,
                          ),
                          widget.uid == FirebaseAuth.instance.currentUser!.uid
                              ? GeneralButton(
                                  onPressed: selectImage,
                                  child: Text(
                                      imageUploaded
                                          ? 'Edit Image'
                                          : 'Upload Image',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inria',
                                        fontSize: 14,
                                      )))
                              : Container(),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(children: [
                          //UserName
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              userData['name'] ?? 'User',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 15),

                          //Followers, Following, Posts
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(followers, "followers"),
                              buildStatColumn(following, "following"),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, "posts"),
                              buildStatColumn(petitions, "petitions")
                            ],
                          ),
                        ]),
                      ),
                      const SizedBox(height: 15),

                      //Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? GeneralButton(
                                  child: const Text('Sign Out',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inria',
                                          fontSize: 14)),
                                  onPressed: () async {
                                    await AuthServices.signOut();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                )
                              : isFollowing
                                  ? GeneralButton(
                                      child: const Text('Unfollow',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Inria',
                                            fontSize: 14,
                                          )),
                                      onPressed: () async {
                                        await FireStoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                            'users',
                                            widget.collection);

                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    )
                                  : GeneralButton(
                                      child: const Text('Follow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inria',
                                              fontSize: 14)),
                                      onPressed: () async {
                                        await FireStoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                            'users',
                                            widget.collection);

                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    )
                        ],
                      ),

                      const SizedBox(height: 20),
                      Text(widget.collection == 'users' ? "BIO" : "OUR MISSION",
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Inria',
                              fontSize: 22)),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: widget.collection == 'users'
                                  ? desc ?? 'Bio'
                                  : desc ?? 'Mission'),
                          enabled: enabledField,
                        ),
                      ),

                      widget.uid == FirebaseAuth.instance.currentUser!.uid
                          ? GeneralButton(
                              onPressed: () async {
                                if (!enabledField) {
                                  setState(() {
                                    enabledField = true;
                                  });
                                } else {
                                  setState(() {
                                    enabledField = false;
                                    desc = _descriptionController.text;
                                  });
                                  widget.collection == "users"
                                      ? await FirebaseFirestore.instance
                                          .collection(widget.collection)
                                          .doc(widget.uid)
                                          .update({'bio': desc})
                                      : await FirebaseFirestore.instance
                                          .collection(widget.collection)
                                          .doc(widget.uid)
                                          .update({'mission': desc});
                                }
                              },
                              child: Text(
                                  enabledField
                                      ? 'Save'
                                      : widget.collection == 'users'
                                          ? 'Edit Bio'
                                          : 'Edit Mission',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                  )))
                          : Container(),
                    ],
                  ),
                ),
                const Divider(),
                widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: EdgeInsets.symmetric(horizontal: 70),
                        child: GeneralButton(
                            child: const Text('Add Post',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontSize: 10)),
                            onPressed: () =>
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => AddPostScreen(
                                      uid: userData['uid'],
                                      name: userData['name'],
                                      photourl: userData['photourl'],
                                    ),
                                  ),
                                )))
                    : Container(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inria'),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                fontFamily: 'Inria'),
          ),
        ),
      ],
    );
  }
}
