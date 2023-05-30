// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin_signup/DAL/dao.dart';

import '../components/my_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({required Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isVisible = false;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _passwordAct = TextEditingController();
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
              "Changer votre mot de passe",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            SizedBox(height: 15),
            Text(
              "Nous vous conseillons d'utiliser un mot de passe sur que vous n'utiliser nulle part ailleurs.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 80),
            // pswd actuel
            TextField(
              controller: _passwordController,
              obscureText: !_isVisible,
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
                    "Mot de passe actuel", //show to the user what to type in that text field
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
                suffixIconColor: Colors.grey[600],
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: !_isVisible,
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
                    "Nouveau mot de passe", //show to the user what to type in that text field
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
                suffixIconColor: Colors.grey[600],
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isVisible,
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
                    "Confirmer le mot de passe", //show to the user what to type in that text field
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
                suffixIconColor: Colors.grey[600],
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            MyButton(
              Ontap: () {
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                // Add your password validation logic here
                if (passwordAct.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                  // Show an error message if either field is empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Please fill in both password fields."),
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
                } else if (password != confirmPassword) {
                  // Show an error message if passwords do not match
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Passwords do not match."),
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
                  user!
                      .updatePassword(password)
                      .then((_) {})
                      .catchError((error) {});
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
                              .update({'password': password})
                              .then((_) {
                                print("Password updated successfully: $password");
                                Navigator.pop(context);
                              }).catchError((error) {
                                print("Error updating password: $error");
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
              name: 'Changer mot de passe',
            ),
          ],
        ),
      ),
    );
  }
}
