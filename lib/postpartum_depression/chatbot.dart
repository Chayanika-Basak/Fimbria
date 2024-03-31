import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../confidential.dart';

class ChatBot extends StatelessWidget {
  const ChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 233, 172, 192)),
        useMaterial3: true,
      ),
      home: const MyChatBot(),
    );
  }
}

class MyChatBot extends StatefulWidget {
  const MyChatBot({
    super.key,
  });

  @override
  State<MyChatBot> createState() => _MyChatBotState();
}

class _MyChatBotState extends State<MyChatBot> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Lets Talk! 💞"),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Text Only"),
                  Tab(text: "Text with Image"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [TextOnly(), TextWithImage()],
            )));
  }
}

// ------------------------------ Text Only ------------------------------

class TextOnly extends StatefulWidget {
  const TextOnly({
    super.key,
  });

  @override
  State<TextOnly> createState() => _TextOnlyState();
}

class _TextOnlyState extends State<TextOnly> {
  bool loading = false;
  String response = "error";
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List textChat = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  // CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  @override
  void initState() {
    super.initState();
    getChats();
  }

  Future<void> getChats() async {
    // print("In getChats");
    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      textChat = userSnap['text_chats'];
    });
    // print("Text Chat:");
    // print(textChat);
  }

  // Text only input
  Future<void> fromText({required String query}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      loading = true;
      textChat.add({
        "role": userSnap['name'].split(' ')[0],
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) async {
      setState(() {
        loading = false;
        response = value.text;
        textChat.add({
          "role": "Fimbry",
          "text": value.text.replaceAll('*', ''),
        });
      });
      scrollToTheEnd();
      await _firestore.collection('users').doc(uid).update({
        'text_chats': FieldValue.arrayUnion([
          {
            "role": userSnap['name'].split(' ')[0],
            "text": query,
          },
          {
            "role": "Fimbry",
            "text": value.text.replaceAll('*', ''),
          }
        ]),
      });
    }).onError((error, stackTrace) async {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Fimbry",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: textChat.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  child: Text(textChat[index]["role"].substring(0, 1)),
                ),
                title: Text(textChat[index]["role"]),
                subtitle: Text(textChat[index]["text"]),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "What's bothering you?",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    fillColor: Colors.transparent,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              IconButton(
                icon: loading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send),
                onPressed: () {
                  fromText(query: _textController.text);
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}

// ------------------------------ Text with Image ------------------------------

class TextWithImage extends StatefulWidget {
  const TextWithImage({
    super.key,
  });

  @override
  State<TextWithImage> createState() => _TextWithImageState();
}

class _TextWithImageState extends State<TextWithImage> {
  bool loading = false;
  File? imageFile;
  String response = "error";
  List textAndImageChat = [];

  final ImagePicker picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  @override
  void initState() {
    super.initState();
    getChats();
  }

  Future<void> getChats() async {
    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      textAndImageChat = userSnap['text_and_image_chats'];
    });
    // print("Text and Image Chat:");
    // print(textAndImageChat);
  }

  // Text and Image input
  Future<void> fromTextAndImage(
      {required String query, required File image}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      loading = true;
      textAndImageChat.add({
        "role": userSnap['name'].split(' ')[0],
        "text": query,
        "image": image,
      });
      _textController.clear();
      imageFile = null;
    });
    scrollToTheEnd();

    gemini
        .generateFromTextAndImages(query: query, image: image)
        .then((value) async {
      setState(() {
        loading = false;
        response = value.text;
        textAndImageChat
            .add({"role": "Fimbry", "text": value.text, "image": ""});
      });
      scrollToTheEnd();
      await _firestore.collection('users').doc(uid).update({
        'text_and_image_chats': FieldValue.arrayUnion([
          {
            "role": userSnap['name'].split(' ')[0],
            "text": query,
            "image": "",
          },
          {"role": "Fimbry", "text": value.text, "image": ""}
        ])
      });
    }).onError((error, stackTrace) async {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Fimbry", "text": error.toString(), "image": ""});
      });
      scrollToTheEnd();
      await _firestore.collection('users').doc(uid).update({
        'text_and_image_chats': FieldValue.arrayUnion([
          {
            "role": userSnap['name'].split(' ')[0],
            "text": query,
            "image": image,
          },
          {"role": "Fimbry", "text": "error", "image": ""}
        ])
      });
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: textAndImageChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    child:
                        Text(textAndImageChat[index]["role"].substring(0, 1)),
                  ),
                  title: Text(textAndImageChat[index]["role"]),
                  subtitle: Text(textAndImageChat[index]["text"]),
                  trailing: textAndImageChat[index]["image"] == ""
                      ? null
                      : Image.file(
                          textAndImageChat[index]["image"],
                          width: 90,
                        ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Show me what's bothering you",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none),
                      fillColor: Colors.transparent,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () async {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      imageFile = image != null ? File(image.path) : null;
                    });
                  },
                ),
                IconButton(
                  icon: loading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                  onPressed: () {
                    if (imageFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please select an image")));
                      return;
                    }
                    fromTextAndImage(
                        query: _textController.text, image: imageFile!);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: imageFile != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 80),
              height: 150,
              child: Image.file(imageFile ?? File("")),
            )
          : null,
    );
  }
}
