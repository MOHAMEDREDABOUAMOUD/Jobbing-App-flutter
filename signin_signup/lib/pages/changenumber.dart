import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin_signup/DAL/dao.dart';
class ChangeNumber extends StatefulWidget {
  const ChangeNumber({super.key});

  @override
  State<ChangeNumber> createState() => _ChangeNumberState();
}

class _ChangeNumberState extends State<ChangeNumber> {
  TextEditingController _numberphone= TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Change Number phone",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              "Set a Number Phone",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15,),
            Text(
              "Please Set a new Number Phone.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: _numberphone,
              decoration: InputDecoration(
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: "Number Phone",
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(height: 15),
            
            SizedBox(height: 30),
            ElevatedButton(
              
              onPressed: () {
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
                              .update({'phone': number})
                              .then((_) {
                                print("phone updated successfully: $number");
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
              child: Text("Change Number Phone"),
            ),
          ],
        ),
      ),
    );
  }
}