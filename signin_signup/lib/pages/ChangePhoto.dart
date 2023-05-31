// ignore_for_file: prefer_const_constructors, unnecessary_cast

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChangePhoto extends StatefulWidget {
  final String email;
  const ChangePhoto({super.key, required this.email});

  @override
  State<ChangePhoto> createState() => _ChangePhotoState();
}

class _ChangePhotoState extends State<ChangePhoto> {
  String imageUrl = "";
  File? profile = null;

  void PickImage() async {
    // ignore: unused_local_variable
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageUrl = image.name;
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
        imageUrl = image.name;
        profile = File(image.path);
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getImage();
    });
    super.initState();
  }

  Future<void> getImage() async {
    Map<String, String> res = {};
    String res1 = await DAO.getType(widget.email) as String;
    if (res1 != "") {
      res = await DAO.getSenderInformationsForProfile(res1, widget.email)
          as Map<String, String>;
      if (res.length > 0) {
        File? file = null;
        await Future.delayed(Duration.zero); // Wait for the next frame
        file = await getFile(res["sender_image"]!);
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            imageUrl = res["sender_image"]!;
            profile = file;
          });
        }
      }
    }
  }

  Future<File> getFile(String url) async {
    final http.Response responseData = await http.get(Uri.parse(url));
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    Directory tempDir = Directory.systemTemp;
    print("******************************");
    return await File('${tempDir.path}/img').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
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

                SizedBox(height: 150),
                //photo
                GestureDetector(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profile != null
                            ? FileImage(profile!) as ImageProvider
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
                SizedBox(height: 40),
                //button register
                MyButton(
                  Ontap: (() async {
                    DAO.updateImage(widget.email, profile);
                  }),
                  name: "Changer photo",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
