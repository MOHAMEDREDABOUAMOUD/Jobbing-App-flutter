// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signin_signup/pages/home_page.dart';

final _firestore = FirebaseFirestore.instance;
late User SignedInUser; //this will give me email

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

  final _auth = FirebaseAuth.instance;
  String? MessageText; //this will give me message

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var msg in messages.docs){
  //     print(msg.data());
  //   }
  // }

  // void messagesStream() async {
  //   await for (var spanshot in _firestore.collection('messages').snapshots()){
  //     for (var msg in spanshot.docs){
  //       print(msg.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 93, 82, 84),
        title: Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset(
            //   'assets/images/logo.png',
            //   height: 35,
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            Text(
              "User: ${widget.receiver}",
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
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
                        // final DocumentReference docRef = FirebaseFirestore
                        //     .instance
                        //     .collection('messages')
                        //     .doc(HomePage.uiddoc);
                        //print(HomePage.uiddoc);

                        // Update the fields you want to change
                        // docRef.update({
                        //   'text': MessageText,
                        //   'time': FieldValue.serverTimestamp(),
                        // });
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
            '$sender',
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
          ),
        ],
      ),
    );
  }
}
