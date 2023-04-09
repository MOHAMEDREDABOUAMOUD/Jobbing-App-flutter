// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_cast, unused_local_variable

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signin_signup/pages/home_page.dart';
import 'package:signin_signup/pages/profile.dart';

final _firestore = FirebaseFirestore.instance;
late User SignedInUser; //this will give me email
String nameR = "", nameS = "";
String collectionS = "client", collectionR = "client";

class ChatScreen extends StatefulWidget {
  //static const String screenRoute = 'chat_screen';
  final String receiver;
  final String sender;

  const ChatScreen({super.key, required this.receiver, required this.sender});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String profileR = "", profileS = "";

  final _auth = FirebaseAuth.instance;
  String? MessageText; //this will give me message

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getType();
      getInfoR();
      getInfoS();
    });
  }

  Future<void> getType() async {
    try {
      final info = await FirebaseFirestore.instance.collection('client');
      final query = await info.where('email', isEqualTo: widget.sender);
      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        collectionS = "client";
      } else {
        collectionS = "prestataire";
      }

      final info1 = await FirebaseFirestore.instance.collection('client');
      final query1 = await info1.where('email', isEqualTo: widget.receiver);
      final snapshot1 = await query1.get();

      if (snapshot1.docs.isNotEmpty) {
        collectionR = "client";
      } else {
        collectionR = "prestataire";
      }
    } catch (e) {
      print(e);
    }
  }

  void getInfoR() async {
    await _getInfoReceiver();
  }

  void getInfoS() async {
    await _getInfoSender();
  }

  Future<void> _getInfoReceiver() async {
    try {
      var userBase = await FirebaseFirestore.instance
          .collection(collectionR)
          .where("email", isEqualTo: widget.receiver)
          .get();
      if (userBase.docs.isNotEmpty) {
        setState(() {
          nameR = userBase.docs[0]['name'];
        });
      }
      await FirebaseStorage.instance
          .ref('profiles')
          .child(widget.receiver)
          .getDownloadURL()
          .then(
        (value) {
          setState(
            () {
              profileR = value;
            },
          );
        },
      );
    } catch (e) {
      print(
          "error R**************************************************************");
    }
  }

  Future<void> _getInfoSender() async {
    try {
      var userBase = await FirebaseFirestore.instance
          .collection(collectionS)
          .where("email", isEqualTo: widget.sender)
          .get();
      if (userBase.docs.isNotEmpty) {
        setState(() {
          nameS = userBase.docs[0]['name'];
        });
      }
      // setState(() async {
      //   await FirebaseStorage.instance
      //       .ref('profiles')
      //       .child(widget.sender)
      //       .getDownloadURL()
      //       .then((value) => profileS = value);
      // });
    } catch (e) {
      print(
          "error S**************************************************************");
    }
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        SignedInUser = user;
        print(SignedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Worker(
                      sender: widget.sender,
                      receiver: widget.receiver,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: profileR != ""
                    ? NetworkImage(profileR)
                    : NetworkImage(
                        'https://www.w3schools.com/howto/img_avatar.png'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  nameR,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       _auth.signOut();
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.close),
        //   )
        // ],
      ),
      body: SafeArea(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(
                receiver: widget.receiver, sender: widget.sender),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 190, 131, 169),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        MessageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your Message here ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        // Get a reference to the Firestore document you want to update
                        CollectionReference colRef =
                            FirebaseFirestore.instance.collection('messages');
                        colRef.add({
                          'receiver': widget.receiver,
                          'sender': widget.sender,
                          'text': MessageText,
                          'time': FieldValue.serverTimestamp(),
                        });
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Color.fromARGB(255, 160, 98, 125),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  final String receiver;
  final String sender;
  const MessageStreamBuilder(
      {super.key, required this.receiver, required this.sender});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }

        final messages = snapshot.data!.docs.reversed;

        for (var msg in messages) {
          final messagereceiver = msg.get('receiver'); //receiver
          final messageSender = msg.get('sender');
          final messageText = msg.get('text');
          final currentUser = sender;
          final receiverUser = receiver;

          if (messageSender == sender && messagereceiver == receiver) {
            final messageWidget = MessageLine(
                sender: messageSender,
                isMe: true,
                isRec: false,
                text: messageText);
            messageWidgets.add(messageWidget);
          } else if (messageSender == receiver && messagereceiver == sender) {
            final messageWidget = MessageLine(
                sender: messageSender,
                isMe: false,
                isRec: true,
                text: messageText);
            messageWidgets.add(messageWidget);
          }
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine(
      {this.text,
      this.sender,
      required this.isMe,
      required this.isRec,
      super.key});

  final String? sender;
  final String? text;
  final bool isMe;
  final bool isRec;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? '${nameS}' : '${nameR}',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.blue[800] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text('$text',
                  style: TextStyle(
                      fontSize: 15, color: isMe ? Colors.white : Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}
