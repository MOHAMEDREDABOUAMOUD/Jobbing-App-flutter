// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin_signup/DAL/dao.dart';

import '../components/my_button.dart';

class ChangeNumber extends StatefulWidget {
  const ChangeNumber({super.key});

  @override
  State<ChangeNumber> createState() => _ChangeNumberState();
}

class _ChangeNumberState extends State<ChangeNumber> {
  TextEditingController _numberphone = TextEditingController();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Text(
              "Changer votre numéro de téléphone",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            SizedBox(height: 15),
            Text(
              "Veuillez saisir un numéro valide",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _numberphone,
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
                hintText:
                    "Nouveau téléphone", //show to the user what to type in that text field
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.phone),
                prefixIconColor: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            SizedBox(height: 30),
            MyButton(
              Ontap: () {
                String number = _numberphone.text;
                if (number.isEmpty) {
                  // Show an error message if either field is empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Number Phone is Empty."),
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
                                  .update({'phone': number}).then((_) {
                                print("phone updated successfully: $number");
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
              name: 'Changer Téléphone',
            ),
          ],
        ),
      ),
    );
  }
}
