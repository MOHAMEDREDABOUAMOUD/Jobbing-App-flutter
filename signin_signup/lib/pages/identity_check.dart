// ignore_for_file: prefer_const_constructors, unnecessary_cast, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signin_signup/pages/home_page.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  String serviceController = "Plombier";

  _IdentityCheckState();
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
    if (widget.pass == widget.repass) {
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
            email: widget.email,
            password: widget.pass,
          );
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: widget.email,
            password: widget.pass,
          );
        } catch (e) {}
      }
      //add user infos to cloud
      await addUserinformations();
      await addUserIdentity();
      Navigator.pop(context);
      //Navigator.pop(context);
    } else {
      showErrorMessag();
    }
  }

  addUserIdentity() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    try {
      await storage
          .ref('profiles/${widget.email}-front')
          .putFile(cardFront); //file name
      await storage
          .ref('profiles/${widget.email}-back')
          .putFile(cardBack); //file name
    } catch (e) {}
  }

  addUserinformations() async {
    await FirebaseFirestore.instance.collection("prestataire").add({
      'name': widget.name,
      'email': widget.email,
      'phone': widget.phone,
      'password': widget.pass,
      'latitude': 0,
      'longitude': 0,
      'service': serviceController,
      'description': descriptionController.text,
      'rate': 0.0,
      'nbRates': 0
    });
  }

  void PickFront() async {
    // ignore: unused_local_variable
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    print(
        "image was picked************************************************************************************************");
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

  Future<bool> checkIdentity(img.Image image) async {
    // Convert the image to grayscale
    img.Image grayscaleImage = img.grayscale(image);

    // Define the Laplacian filter
    List<num> laplacianFilter = [0, 1, 0, 1, -4, 1, 0, 1, 0];

    // Apply the Laplacian filter to the grayscale image
    img.Image filteredImage =
        img.convolution(grayscaleImage, filter: laplacianFilter);

    // Compute the variance of the Laplacian
    double mean = 0.0;
    int count = 0;
    for (int y = 0; y < filteredImage.height; y++) {
      for (int x = 0; x < filteredImage.width; x++) {
        var pixel = filteredImage.getPixel(x, y);
        int gray = img.getLuminance(pixel).round();
        mean += gray;
        count++;
      }
    }
    mean /= count;

    double variance = 0.0;
    for (int y = 0; y < filteredImage.height; y++) {
      for (int x = 0; x < filteredImage.width; x++) {
        var pixel = filteredImage.getPixel(x, y);
        int gray = img.getLuminance(pixel).round();
        variance += pow(gray - mean, 2);
      }
    }
    variance /= count - 1;
    print(
        '$variance****************************************************************************');
    // Determine if the image is clear or not based on the variance of the Laplacian
    if (variance < 50) {
      return false;
    } else {
      return true;
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
        centerTitle: true,
        backgroundColor: Colors.grey[700],
        title: Text("Identity Check"),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
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
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: serviceController,
                        items: [
                          DropdownMenuItem(
                            value: 'Plombier',
                            child: Text('Plombier'),
                          ),
                          DropdownMenuItem(
                            value: 'Electricite',
                            child: Text('Electricite'),
                          ),
                          DropdownMenuItem(
                            value: 'Renovation',
                            child: Text('Renovation'),
                          ),
                          DropdownMenuItem(
                            value: 'Jardinage',
                            child: Text('Jardinage'),
                          ),
                          DropdownMenuItem(
                            value: 'Demenagement',
                            child: Text('Demenagement'),
                          ),
                          DropdownMenuItem(
                            value: 'Menage',
                            child: Text('Menage'),
                          ),
                          DropdownMenuItem(
                            value: 'Baby sitting',
                            child: Text('Baby sitting'),
                          ),
                          DropdownMenuItem(
                            value: 'Cours particuliers',
                            child: Text('Cours particuliers'),
                          ),
                          DropdownMenuItem(
                            value: 'informatique',
                            child: Text('informatique'),
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
                  'take a clear picture of your identity here',
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
                            image: AssetImage('lib/images/fb.jpg'),
                            width: 300,
                            height: 100,
                          ),
                    GestureDetector(
                      onTap: () {
                        PickFront();
                      },
                      child: Icon(Icons.camera),
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
                            image: AssetImage('lib/images/fb.jpg'),
                            width: 300,
                            height: 100,
                          ),
                    GestureDetector(
                      onTap: () {
                        PickBack();
                      },
                      child: Icon(Icons.camera),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MyButton(
                  Ontap: (() async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    try {
                      if (await checkIdentity(
                                  await fileToImage(cardFront) as img.Image)
                              as bool &&
                          await checkIdentity(
                                  await fileToImage(cardBack) as img.Image)
                              as bool) {
                        SignUserUp(false);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              emailMe: widget.email,
                            ),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("picture not clear"),
                              );
                            });
                      }
                    } catch (e) {}
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
