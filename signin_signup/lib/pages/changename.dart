// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin_signup/DAL/dao.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({super.key});

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  TextEditingController _nameUser = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        toolbarHeight: 70,
        title: Text(
          //widget.name,
          "Smart Jobbing",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 150),
            Text(
              "Veuillez entrer un nom.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _nameUser,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.amber,
                    )),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                hintText: "Utilisateur",
                prefixIcon: Icon(Icons.person),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String name = _nameUser.text;
                if (name.isEmpty) {
                  // Show an error message if either field is empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Name User is Empty."),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser != null) {
                    String? userEmail = currentUser.email;
                    if (userEmail != null) {
                      Future<String> futureResult = DAO.getType(userEmail);
                      futureResult.then((value) => FirebaseFirestore.instance
                              .collection(value)
                              .where('email', isEqualTo: userEmail)
                              .get()
                              .then((QuerySnapshot snapshot) {
                            if (snapshot.docs.isNotEmpty) {
                              String documentId = snapshot.docs[0].id;
                              FirebaseFirestore.instance
                                  .collection(value)
                                  .doc(documentId)
                                  .update({'name': name}).then((_) {
                                print("phone updated successfully: $name");
                                Navigator.pop(context);
                              }).catchError((error) {
                                print("Error updating phone: $error");
                              });
                            } else {
                              print("User document not found");
                            }
                          }).catchError((error) {
                            print("Error retrieving user document: $error");
                          }));
                    } else {
                      print("User email is null");
                    }
                  } else {
                    print("User is null");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                minimumSize: Size(50, 60),
              ),
              child: Text(
                "Changer nom d'utilisateur",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
