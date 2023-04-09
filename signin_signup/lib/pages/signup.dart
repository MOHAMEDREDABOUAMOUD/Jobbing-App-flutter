// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_cast, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:signin_signup/components/square_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cross_file_image/cross_file_image.dart';
import 'package:signin_signup/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:signin_signup/pages/identity_check.dart';

import '../components/my_textfield.dart';
import '../components/passTextField.dart';
import '../services/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var profile;
  String profileName = "";
  String? type = "client";
  String buttonText = "SignUp";
  bool isclient = true, isprest = false;
  TextEditingController userController = TextEditingController();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passcontroller1 = TextEditingController();
  TextEditingController passcontroller2 = TextEditingController();
  //TextEditingController descriptionController = TextEditingController();

  // ignore: non_constant_identifier_names
  showErrorMessag() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Password don't match"),
          );
        });
  }

  SignUserUp(bool google) async {
    if (passcontroller1.text == passcontroller2.text) {
      //show loading circle
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      //signup
      if (google == false) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailContoller.text,
            password: passcontroller1.text,
          );
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailContoller.text,
            password: passcontroller1.text,
          );
        } catch (e) {}
      }
      //add user infos to cloud
      addUserinformations();
      addUserImage(google);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      showErrorMessag();
    }
  }

  addUserinformations() async {
    await FirebaseFirestore.instance.collection("client").add({
      'name': userController.text,
      'email': emailContoller.text,
      'phone': phoneController.text,
      'password': passcontroller1.text,
      'latitude': 0,
      'longitude': 0
    });
  }

  addUserImage(bool google) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    try {
      if (!google) {
        await storage
            .ref('profiles/${emailContoller.text}')
            .putFile(profile); //file name
      } else {
        http.Response response = await http.get(Uri.parse(profile));
        await storage
            .ref('profiles/${emailContoller.text}')
            .putData(response.bodyBytes); //file name
      }
      profileName =
          await storage.ref('profiles/${emailContoller.text}').getDownloadURL();
    } catch (e) {}
  }

  void PickImage() async {
    // ignore: unused_local_variable
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        profileName = image.name;
        profile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Text(
            'SignUp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                //Welcome to our app

                SizedBox(height: 5),
                Text(
                  'Welcome to our App!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 110),
                  child: Divider(
                    height: 10,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 5),

                //photo
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profile != null
                      ? FileImage(profile) as ImageProvider
                      // ignore: unnecessary_cast
                      : NetworkImage(
                          'https://www.w3schools.com/howto/img_avatar.png'),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Container(
                      // ignore: sort_child_properties_last
                      child: TextButton(
                        onPressed: () {
                          PickImage();
                        },
                        child: Text(
                          'Take a photo',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      color: Colors.grey[500],
                    ),
                  ],
                ),

                SizedBox(height: 5),
                //text fields

                MyTextField(
                  controller: userController,
                  hintText: 'User',
                  ObscureText: false,
                  type: TextInputType.name,
                  icon: Icon(Icons.person),
                  lines: 1,
                ),
                SizedBox(height: 5),
                MyTextField(
                  controller: emailContoller,
                  hintText: 'Email',
                  ObscureText: false,
                  type: TextInputType.emailAddress,
                  icon: Icon(Icons.email),
                  lines: 1,
                ),
                SizedBox(height: 5),
                MyTextField(
                  controller: phoneController,
                  hintText: 'Phone number',
                  ObscureText: false,
                  type: TextInputType.phone,
                  icon: Icon(Icons.phone),
                  lines: 1,
                ),
                SizedBox(height: 5),
                PassTextField(
                  controller: passcontroller1,
                  hintText: 'password',
                ),
                SizedBox(height: 5),
                PassTextField(
                  controller: passcontroller2,
                  hintText: 'Confirm password',
                ),
                SizedBox(height: 5),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Client'),
                      Checkbox(
                        value: isclient,
                        onChanged: (value) {
                          setState(
                            () {
                              isclient = value!;
                              isprest = !isclient;
                              if (isclient == true) {
                                type = "client";
                                buttonText = "SignUp";
                              } else {
                                type = "prestataire";
                                buttonText = "Next";
                              }
                            },
                          );
                        },
                      ),
                      Text('prestataire'),
                      Checkbox(
                        value: isprest,
                        onChanged: (value) {
                          setState(() {
                            isprest = value!;
                            isclient = !isprest;
                            if (isclient == true) {
                              type = "client";
                              buttonText = "SignUp";
                            } else {
                              type = "prestataire";
                              buttonText = "Next";
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),

                //button register
                MyButton(
                  Ontap: (() async {
                    if (type == "client") {
                      await SignUserUp(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            emailMe: emailContoller.text,
                          ),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => IdentityCheck(
                      //       profile: profileName,
                      //       name: userController.text,
                      //       phone: phoneController.text,
                      //       email: emailContoller.text,
                      //       isClient: true,
                      //       pass: '',
                      //       repass: '',
                      //     ),
                      //   ),
                      // );
                    } else {
                      addUserImage(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IdentityCheck(
                            name: userController.text,
                            phone: phoneController.text,
                            email: emailContoller.text,
                            isClient: false,
                            pass: passcontroller1.text,
                            repass: passcontroller2.text,
                          ),
                        ),
                      );
                    }
                  }),
                  name: buttonText,
                ),
                SizedBox(height: 5),
                //or continue with

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 60,
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
                          height: 60,
                          thickness: 0.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                //google + apple sign in

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(
                      imagePath: 'lib/images/google.png',
                      OnTap: () async {
                        await AuthService().signInWithGoogle();
                        Map<String, String> result = AuthService.Result();
                        emailContoller.text = result['email'].toString();
                        userController.text = result['name'].toString();
                        profile = result['profile'].toString();
                        SignUserUp(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              emailMe: emailContoller.text,
                            ),
                          ),
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => IdentityCheck(
                        //       profile: result['profile'].toString(),
                        //       name: result['name'].toString(),
                        //       phone: "",
                        //       email: result['email'].toString(),
                        //       isClient: false,
                        //       pass: '',
                        //       repass: '',
                        //     ),
                        //   ),
                        // );
                      },
                    ),

                    // const SizedBox(
                    //   width: 5,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
