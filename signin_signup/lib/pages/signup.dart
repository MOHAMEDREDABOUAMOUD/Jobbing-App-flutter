// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_cast, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:signin_signup/components/square_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cross_file_image/cross_file_image.dart';
import 'package:signin_signup/pages/home_page.dart';
import 'package:signin_signup/pages/messagerie.dart';
import 'package:http/http.dart' as http;
import 'package:signin_signup/pages/identity_check.dart';
import 'package:signin_signup/services/business.dart';

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
  String buttonText = "S'inscrire";
  bool isclient = true, isprest = false;
  TextEditingController userController = TextEditingController();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passcontroller1 = TextEditingController();
  TextEditingController passcontroller2 = TextEditingController();
  //TextEditingController descriptionController = TextEditingController();

  // ignore: non_constant_identifier_names

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

  void PickImage2() async {
    // ignore: unused_local_variable
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);
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
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                //Welcome to our app

                SizedBox(height: 20),
                //photo
                GestureDetector(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profile != null
                            ? FileImage(profile) as ImageProvider
                            // ignore: unnecessary_cast
                            : NetworkImage(
                                'https://www.w3schools.com/howto/img_avatar.png'),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Photo de profile",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.camera_alt,
                                      color: Colors.grey[700]),
                                  onPressed: () {
                                    PickImage();
                                  },
                                ),
                                SizedBox(width: 30),
                                IconButton(
                                    onPressed: () {
                                      PickImage2();
                                    },
                                    icon: Icon(Icons.photo_library,
                                        color: Colors.grey[700]))
                              ],
                            ),
                          );
                        });
                  },
                ),

                SizedBox(height: 30),
                //text fields

                MyTextField(
                  controller: userController,
                  hintText: 'Utilisateur',
                  ObscureText: false,
                  type: TextInputType.name,
                  icon: Icon(Icons.person),
                  lines: 1,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: emailContoller,
                  hintText: 'Adresse e-mail',
                  ObscureText: false,
                  type: TextInputType.emailAddress,
                  icon: Icon(Icons.email),
                  lines: 1,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: phoneController,
                  hintText: ' Téléphone',
                  ObscureText: false,
                  type: TextInputType.phone,
                  icon: Icon(Icons.phone),
                  lines: 1,
                ),
                SizedBox(height: 10),
                PassTextField(
                  controller: passcontroller1,
                  hintText: 'Mot de passe',
                ),
                SizedBox(height: 10),
                PassTextField(
                  controller: passcontroller2,
                  hintText: 'Confirmer mot de passe',
                ),
                SizedBox(height: 10),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Client',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      Checkbox(
                        value: isclient,
                        onChanged: (value) {
                          setState(
                            () {
                              isclient = value!;
                              isprest = !isclient;
                              if (isclient == true) {
                                type = "client";
                                buttonText = "S'inscrire";
                              } else {
                                type = "prestataire";
                                buttonText = "Suivant";
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(width: 30),
                      Text(
                        'prestataire',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      Checkbox(
                        value: isprest,
                        onChanged: (value) {
                          setState(() {
                            isprest = value!;
                            isclient = !isprest;
                            if (isclient == true) {
                              type = "client";
                              buttonText = "S'inscrire";
                            } else {
                              type = "prestataire";
                              buttonText = "Suivant";
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                //button register
                MyButton(
                  Ontap: (() async {
                    if (type == "client") {
                      await services.SignUserUpC(
                          false,
                          context,
                          emailContoller.text,
                          passcontroller1.text,
                          passcontroller2.text,
                          userController.text,
                          phoneController.text,
                          profile,
                          profileName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Main(
                            email: emailContoller.text,
                          ),
                        ),
                      );
                    } else {
                      await services.addUserImage(
                          false, emailContoller.text, profile, profileName);
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
                          'Etes-vous un client? Continuez avec Google',
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
                        await services.SignUserUpC(
                            true,
                            context,
                            emailContoller.text,
                            "",
                            "",
                            userController.text,
                            "",
                            profile,
                            "");
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Main(
                              email: emailContoller.text,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
