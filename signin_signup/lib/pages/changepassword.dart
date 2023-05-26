import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin_signup/DAL/dao.dart';


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
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              "Set a password",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15,),
            Text(
              "Please create a secure password including the following criteria below.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: _passwordController,
              obscureText: !_isVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: "Password",
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: "Confirm Password",
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                // Add your password validation logic here
                if (password.isEmpty || confirmPassword.isEmpty) {
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
                  user!.updatePassword(password).then((_) {
                    
                  }).catchError((error) {
                    
                  });
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
                              })
                              .catchError((error) {
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
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
              ),
              child: Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
