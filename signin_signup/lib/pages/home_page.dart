// ignore_for_file: prefer_const_constructors, annotate_overrides

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/pages/chat_page.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  //final FileImage? profile;

  //static String uiddoc = "";
  final _firestore = FirebaseFirestore.instance;
  late User SignedInUser;
  String receiveruser = "";
  //final String name, phone, description, profile;
  final String emailMe;
  HomePage({
    super.key,
    required this.emailMe,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String collection = "client";

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentUser();
    });
    print(
        "***************************************************************************************************************************");
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        widget.SignedInUser = user;
      }
      collection = await DAO.getType(widget.emailMe) as String;
      // CollectionReference info =
      //     FirebaseFirestore.instance.collection('client');
      // var userBase = await info.where("email", isEqualTo: widget.emailMe).get();
      // if (userBase.docs.isNotEmpty) {
      //   collection = "client";
      // } else {
      //   collection = "prestataire";
      // }
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
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: Rx.combineLatest2<QuerySnapshot<Map<String, dynamic>>,
            QuerySnapshot<Map<String, dynamic>>, List<String>>(
          _db.collection('client').snapshots(),
          _db.collection('prestataire').snapshots(),
          (clientSnapshot, prestataireSnapshot) {
            final List<String> clientEmails = clientSnapshot.docs
                .map((doc) => doc.data()['email'] as String)
                .toList();
            final List<String> prestataireEmails = prestataireSnapshot.docs
                .map((doc) => doc.data()['email'] as String)
                .toList();
            return clientEmails + prestataireEmails;
          },
        ),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading emails'));
          }
          final buttons = snapshot.data!
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
