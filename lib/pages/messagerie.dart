// ignore_for_file: prefer_const_constructors, annotate_overrides, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/pages/chat_page.dart';
import 'package:rxdart/rxdart.dart';

class Messagerie extends StatefulWidget {
  //final FileImage? profile;

  //static String uiddoc = "";
  final _firestore = FirebaseFirestore.instance;
  late User SignedInUser;
  String receiveruser = "";
  //final String name, phone, description, profile;
  final String emailMe;
  Messagerie({
    super.key,
    required this.emailMe,
  });

  @override
  State<Messagerie> createState() => _MessagerieState();
}

class _MessagerieState extends State<Messagerie> {
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

  Future<String> getUserName(String email) async {
    return await DAO.getUserName(email);
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        widget.SignedInUser = user;
      }
      collection = await DAO.getType(widget.emailMe) as String;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        toolbarHeight: 70,
        title: Text(
          "Smart Jobbing",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: Stream.fromFuture(DAO.getTalkTo(widget.emailMe)),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, String>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading emails'));
          }
          final buttons = snapshot.data!
              .map(
                (email) => ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ChatScreen(
                          sender: widget.emailMe,
                          receiver: email.keys
                              .toString()
                              .substring(1, email.keys.toString().length - 1),
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    subtitle: Text(
                      "",
                      style: TextStyle(fontSize: 15),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 10, 0),
                    leading: CircleAvatar(
                      backgroundImage: email.values.toString().substring(
                                  1, email.values.toString().length - 1) !=
                              ""
                          ? NetworkImage(email.values
                              .toString()
                              .substring(1, email.values.toString().length - 1))
                          : NetworkImage(
                              'https://www.w3schools.com/howto/img_avatar.png'),
                      radius: 24,
                    ),
                    title: FutureBuilder<String>(
                      future: getUserName(email.keys
                          .toString()
                          .substring(1, email.keys.toString().length - 1)),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return Text(
                          snapshot.data!,
                          style: TextStyle(fontSize: 18),
                        );
                      },
                    ),
                  ),
                ),
              )
              .toList();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttons, //buttons,
              ),
            ),
          );
        },
      ),
    );
  }
}
