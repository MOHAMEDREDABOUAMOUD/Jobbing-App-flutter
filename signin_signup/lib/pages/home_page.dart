// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/pages/chat_page.dart';

class HomePage extends StatefulWidget {
  //final FileImage? profile;

  static String uiddoc = "";
  final _firestore = FirebaseFirestore.instance;
  late User SignedInUser;
  static String receiveruser = "";
  final String name, phone, email, description, profile;
  HomePage(
      {super.key,
      required this.profile,
      required this.name,
      required this.phone,
      required this.email,
      required this.description});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        widget.SignedInUser = user;
        print(widget.SignedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  String generateUserId() {
    final int rand = Random()
        .nextInt(1000000); // Generate a random integer between 0 and 999999
    final String timestamp = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Get the current timestamp in milliseconds
    return '$timestamp$rand'; // Concatenate the timestamp and random integer to create a unique ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 93, 82, 84),
        title: Row(
          children: [
            // Image.asset(
            //   'assets/images/logo.png',
            //   height: 35,
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            Text('List Contacts'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              //_auth.signOut();
              //Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _db.collection('users').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading emails'));
          }
          final List<String> emails = snapshot.data?.docs
                  .map((doc) => doc.data()['email'] as String)
                  .toList() ??
              [];
          final List<Widget> buttons = emails
              .map((email) => ElevatedButton(
                    onPressed: () {
                      final String userId = generateUserId();

                      // Get a reference to the Firestore collection where you want to add the document
                      final CollectionReference messagesRef =
                          FirebaseFirestore.instance.collection('messages');

                      // Create a reference to the document with the preferred UID
                      final DocumentReference docRef = messagesRef.doc(userId);

                      // Set the data for the document
                      docRef.set({
                        'sender': widget.SignedInUser.email,
                        'receiver': email,
                        'text': '',
                        'time': FieldValue.serverTimestamp()
                      });
                      HomePage.uiddoc = userId;
                      HomePage.receiveruser = email;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ChatScreen(
                            receiver: HomePage.receiveruser,
                          ),
                        ),
                      );
                    },
                    child: Text(email),
                  ))
              .toList();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buttons,
            ),
          );
        },
      ),
    );
  }

  // sign user out methode
  // void signUserOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       actions: [
  //         IconButton(
  //             onPressed: () {
  //               signUserOut();
  //               Navigator.pop(context);
  //             },
  //             icon: Icon(Icons.logout))
  //       ],
  //     ),
  //     body: Center(
  //       child: Column(
  //         children: [
  //           Text("LOGGEDIN : "),
  //           CircleAvatar(
  //             radius: 40,
  //             backgroundImage: widget.profile != ""
  //                 ? NetworkImage(widget.profile) //profile as ImageProvider
  //                 // ignore: unnecessary_cast
  //                 : NetworkImage(
  //                     'https://www.w3schools.com/howto/img_avatar.png'),
  //           ),
  //           Text("Name : ${widget.name}"),
  //           Text("E-mail : ${widget.email}"),
  //           Text("Phone : ${widget.phone}"),
  //           Text("Description : ${widget.description}"),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
