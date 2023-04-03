// ignore_for_file: prefer_const_constructors, annotate_overrides

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/pages/chat_page.dart';

class HomePage extends StatefulWidget {
  //final FileImage? profile;

  //static String uiddoc = "";
  final _firestore = FirebaseFirestore.instance;
  late User SignedInUser;
  String receiveruser = "";
  final String name, phone, emailMe, description, profile;
  HomePage(
      {super.key,
      required this.profile,
      required this.name,
      required this.phone,
      required this.emailMe,
      required this.description});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String status = "";

  void initState() {
    super.initState();
    getCurrentUser();
    updateStatus();
  }

  void updateStatus() {
    _updateStatus();
    // ignore: prefer_interpolation_to_compose_strings
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

  Future<void> _updateStatus() async {
    Query query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.emailMe);
    QuerySnapshot snapshot = await query.get();
    snapshot.docs.forEach((doc) async {
      await doc.reference.update({'status': 'online'});
    });
    status = "online";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
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
            onPressed: () async {
              Query query = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: widget.emailMe);
              QuerySnapshot snapshot = await query.get();
              snapshot.docs.forEach((doc) async {
                await doc.reference.update({'status': 'offline'});
              });
              _auth.signOut();
              Navigator.pop(context);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ChatScreen(
                            sender: widget.emailMe,
                            receiver: email,
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
}
