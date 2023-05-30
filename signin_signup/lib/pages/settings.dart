// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:signin_signup/pages/ChangePhoto.dart';
import 'package:signin_signup/pages/changename.dart';
import 'package:signin_signup/pages/changenumber.dart';
import 'package:signin_signup/pages/changepassword.dart';

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
                  Icons.person,
                  color: Colors.orange,
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
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Change Number Phone"),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == "Change Password") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePassword(key: UniqueKey())),
          );
        } else if (title == "Change Number Phone") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangeNumber()),
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
