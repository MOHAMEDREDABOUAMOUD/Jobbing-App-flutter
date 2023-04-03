// ignore_for_file: prefer_const_constructors, unnecessary_cast

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signin_signup/pages/home_page.dart';
import 'package:image/image.dart' as img;

class IdentityCheck extends StatefulWidget {
  final String name, phone, email, description, profile;
  const IdentityCheck(
      {super.key,
      required this.profile,
      required this.name,
      required this.phone,
      required this.email,
      required this.description});

  @override
  State<IdentityCheck> createState() => _IdentityCheckState(
      this.name, this.phone, this.email, this.description, this.profile);
}

class _IdentityCheckState extends State<IdentityCheck> {
  final String name, phone, email, description, profile;
  var cardFront, cardBack;

  _IdentityCheckState(
      this.name, this.phone, this.email, this.description, this.profile);
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
    // Determine if the image is clear or not based on the variance of the Laplacian
    if (variance < 100) {
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
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'take a clear picture of your identity here',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Image(
                      image: cardFront != null
                          ? FileImage(cardFront) as ImageProvider
                          // ignore: unnecessary_cast
                          : NetworkImage(
                              'https://www.w3schools.com/howto/img_avatar.png'),
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Image(
                      image: cardBack != null
                          ? FileImage(cardBack) as ImageProvider
                          // ignore: unnecessary_cast
                          : NetworkImage(
                              'https://www.w3schools.com/howto/img_avatar.png'),
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
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              profile: profile,
                              name: name,
                              phone: phone,
                              emailMe: email,
                              description: description,
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
                  name: 'Check',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
