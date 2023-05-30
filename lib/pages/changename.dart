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
  TextEditingController _nameUser= TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Change Name User",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              "Set a Name User",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15,),
            Text(
              "Please Set a new Name User.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: _nameUser,
              decoration: InputDecoration(
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: "Name User",
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                }else{
                  
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  
                  if (currentUser != null) {
                    String? userEmail = currentUser.email;
                    if (userEmail != null) {
                      Future<String> futureResult = DAO.getType(userEmail);
                      futureResult.then((value) => 
                        FirebaseFirestore.instance
                          .collection(value)
                          .where('email', isEqualTo: userEmail)
                          .get()
                          .then((QuerySnapshot snapshot) {
                        if (snapshot.docs.isNotEmpty) {
                          String documentId = snapshot.docs[0].id;
                          FirebaseFirestore.instance
                              .collection(value)
                              .doc(documentId)
                              .update({'name': name})
                              .then((_) {
                                print("phone updated successfully: $name");
                                Navigator.pop(context);
                              })
                              .catchError((error) {
                                print("Error updating phone: $error");
                              });
                        } else {
                          print("User document not found");
                        }
                      })
                      .catchError((error) {
                        print("Error retrieving user document: $error");
                      })
                      );
                      
                    } else {
                      print("User email is null");
                    }
                  } else {
                    print("User is null");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
              ),
              child: Text("Change Name User"),
            ),
          ],
        ),
      ),
    );
  }
}