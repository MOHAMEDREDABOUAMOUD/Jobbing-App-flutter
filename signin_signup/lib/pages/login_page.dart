// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:signin_signup/components/my_textfield.dart';
import 'package:signin_signup/components/square_tile.dart';
import 'package:signin_signup/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../components/passTextField.dart';
import 'forgotPassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String name;
  late String phone;
  late String description;
  late String urlProfile;
  late File profile;

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Email"),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect password"),
          );
        });
  }

  void signUserIn() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //signin
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      getUserInformations();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  getUserInformations() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    CollectionReference info = FirebaseFirestore.instance.collection('users');
    String docId;
    try {
      var s = await storage.ref('profiles').child(usernameController.text);
      urlProfile = await s.getDownloadURL();
      var userBase =
          await info.where("email", isEqualTo: usernameController.text).get();
      if (userBase != null) {
        name = userBase.docs[0]['name'];
        phone = userBase.docs[0]['phone'];
        description = userBase.docs[0]['description'];
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                //logo
                Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                //welcome back,you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 50),

                //Email textfield

                MyTextField(
                  controller: usernameController,
                  hintText: 'E-mail',
                  ObscureText: false,
                  type: TextInputType.emailAddress,
                  icon: Icon(Icons.email),
                ),

                const SizedBox(height: 10),

                //password textfield

                PassTextField(
                  controller: passwordController,
                  hintText: 'password',
                ),

                const SizedBox(height: 25),

                //forgot password

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ForgotPassword();
                            },
                          ));
                        },
                        child: Text(
                          'forgot password?',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //signin button

                MyButton(
                  Ontap: signUserIn,
                  name: 'Sign In',
                ),

                //or continue with

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 100,
                          thickness: 0.5,
                          color: Colors.grey[700],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 100,
                          thickness: 0.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                //google sign in

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(
                      imagePath: 'lib/images/google.png',
                      OnTap: () {
                        AuthService().signInWithGoogle();
                      },
                    ),

                    // const SizedBox(
                    //   width: 25,
                    // ),
                    //apple button
                    // SquareTile(
                    //   imagePath: 'lib/images/fb.jpg',
                    //   OnTap: () {
                    //     AuthService().signInWithFacebook();
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(height: 25),

                //not a membre? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      // ignore: sort_child_properties_last
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
