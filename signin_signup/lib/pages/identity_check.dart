// ignore_for_file: prefer_const_constructors, unnecessary_cast, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signin_signup/pages/home_page.dart';
import 'package:signin_signup/pages/messagerie.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:signin_signup/services/business.dart';

import '../components/my_textfield.dart';

class IdentityCheck extends StatefulWidget {
  final String name, phone, pass, repass, email;
  final bool isClient;
  const IdentityCheck(
      {super.key,
      required this.name,
      required this.phone,
      required this.email,
      required this.pass,
      required this.repass,
      required this.isClient});

  @override
  State<IdentityCheck> createState() => _IdentityCheckState();
}

class _IdentityCheckState extends State<IdentityCheck> {
  //final String name, phone, email, description, profile;
  var cardFront, cardBack;
  TextEditingController descriptionController = TextEditingController();
  String serviceController = "Plomberie";

  _IdentityCheckState();

  void PickFront() async {
    // ignore: unused_local_variable
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        cardFront = File(image.path);
      });
    }
  }

  void PickBack() async {
    // ignore: unused_local_variable
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        cardBack = File(image.path);
      });
    }
  }

  Future<img.Image?> fileToImage(File file) async {
    // Read the file as bytes
    List<int> bytes = await file.readAsBytes();

    // Decode the bytes to an img.Image object
    return img.decodeImage(Uint8List.fromList(bytes));
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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          'Service : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: serviceController,
                        items: [
                          DropdownMenuItem(
                            value: 'Plomberie',
                            child: Text('Plomberie'),
                          ),
                          DropdownMenuItem(
                            value: 'Eléctricité',
                            child: Text('Eléctricité'),
                          ),
                          DropdownMenuItem(
                            value: 'Rénovation',
                            child: Text('Rénovation'),
                          ),
                          DropdownMenuItem(
                            value: 'Jardinage',
                            child: Text('Jardinage'),
                          ),
                          DropdownMenuItem(
                            value: 'Démenagement',
                            child: Text('Démenagement'),
                          ),
                          DropdownMenuItem(
                            value: 'Ménage',
                            child: Text('Ménage'),
                          ),
                          DropdownMenuItem(
                            value: 'Babysitting',
                            child: Text('Babysitting'),
                          ),
                          DropdownMenuItem(
                            value: 'Cours particuliers',
                            child: Text('Cours particuliers'),
                          ),
                          DropdownMenuItem(
                            value: 'Informatique',
                            child: Text('Informatique'),
                          ),
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            serviceController = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                MyTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  ObscureText: false,
                  type: TextInputType.emailAddress,
                  icon: Icon(Icons.text_snippet_outlined),
                  lines: 5,
                ),
                SizedBox(height: 30),
                Text(
                  'Veuillez prendre une photo de votre cin',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[500]),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    cardFront != null
                        ? Image(
                            image: FileImage(cardFront) as ImageProvider,
                            width: 300,
                            height: 100,
                          )
                        : Image(
                            image: AssetImage('lib/images/frontCard.png'),
                            width: 300,
                            height: 100,
                          ),
                    GestureDetector(
                      onTap: () {
                        PickFront();
                      },
                      child: Icon(Icons.photo_camera),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    cardBack != null
                        ? Image(
                            image: FileImage(cardBack) as ImageProvider,
                            width: 300,
                            height: 100,
                          )
                        : Image(
                            image: AssetImage('lib/images/backCard.png'),
                            width: 300,
                            height: 100,
                          ),
                    GestureDetector(
                      onTap: () {
                        PickBack();
                      },
                      child: Icon(Icons.photo_camera),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MyButton(
                  Ontap: (() async {
                    print(
                        'befordialog*********************************************************************************************');
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    print(
                        'afterdialog*********************************************************************************************');
                    try {
                      // if (await services.checkIdentity(
                      //         await fileToImage(cardFront) as img.Image,
                      //         0.5) as bool &&
                      //     await services.checkIdentity(
                      //             await fileToImage(cardBack) as img.Image, 0.5)
                      //         as bool) {
                      print(
                          'beforesignup*********************************************************************************************');
                      await services.SignUserUp(
                          false,
                          context,
                          widget.email,
                          widget.pass,
                          widget.repass,
                          widget.name,
                          widget.phone,
                          serviceController,
                          descriptionController.text,
                          cardFront,
                          cardBack);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Main(
                            email: widget.email,
                          ),
                        ),
                      );
                      // } else {
                      //   Navigator.pop(context);
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return const AlertDialog(
                      //           title: Text("picture not clear"),
                      //         );
                      //       });
                      // }
                    } catch (e) {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("cant sign up"),
                            );
                          });
                    }
                  }),
                  name: 'SignUp',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
