// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:signin_signup/pages/ChangePhoto.dart';
import 'package:signin_signup/pages/changename.dart';
import 'package:signin_signup/pages/changenumber.dart';
import 'package:signin_signup/pages/changepassword.dart';
import 'package:signin_signup/pages/report.dart';

class Settings_Screen extends StatefulWidget {
  final String email;
  const Settings_Screen({super.key, required this.email});

  @override
  State<Settings_Screen> createState() => _Settings_ScreenState();
}

class _Settings_ScreenState extends State<Settings_Screen> {
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
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "securité",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Divider(
              height: 40,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOption(context, "Changer mot de passe"),
            buildAccountOption(context, "Changer numero téléphone"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Informations personnelle",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOption(context, "Changer nom d'utilisateur"),
            buildAccountOption(context, "Changer photo"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Signal",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOption(context, "Signaler un problème"),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == "Changer mot de passe") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePassword(key: UniqueKey())),
          );
        } else if (title == "Changer numero téléphone") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangeNumber()),
          );
        } else if (title == "Changer nom d'utilisateur") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangeName()),
          );
        } else if (title == "Changer photo") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePhoto(
                      email: widget.email,
                    )),
          );
        } else if (title == "Signaler un problème") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportScreen()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600])),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
