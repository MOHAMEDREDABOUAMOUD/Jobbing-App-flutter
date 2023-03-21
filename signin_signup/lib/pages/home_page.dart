// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //final FileImage? profile;
  final String name, phone, email, description, profile;
  HomePage(
      {super.key,
      required this.profile,
      required this.name,
      required this.phone,
      required this.email,
      required this.description});

  // sign user out methode
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signUserOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("LOGGEDIN : "),
            CircleAvatar(
              radius: 40,
              backgroundImage: profile != ""
                  ? NetworkImage(profile) //profile as ImageProvider
                  // ignore: unnecessary_cast
                  : NetworkImage(
                      'https://www.w3schools.com/howto/img_avatar.png'),
            ),
            Text("Name : $name"),
            Text("E-mail : $email"),
            Text("Phone : $phone"),
            Text("Description : $description"),
          ],
        ),
      ),
    );
  }
}
