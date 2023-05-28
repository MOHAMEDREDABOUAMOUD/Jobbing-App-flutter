// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ClientProfile extends StatefulWidget {
  final String urlImage;
  final String name;
  final String phone;
  final String email;
  final String address;

  const ClientProfile(
      {super.key,
      required this.urlImage,
      required this.name,
      required this.phone,
      required this.email,
      required this.address});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          toolbarHeight: 70,
          title: Text(
            "Smart Jobbing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 83,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: widget.urlImage != ""
                          ? NetworkImage(widget.urlImage)
                          : NetworkImage(
                              'https://www.w3schools.com/howto/img_avatar.png'),
                      radius: 80,
                    )),
                SizedBox(height: 20),
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.grey,
                  height: 30,
                  thickness: 2,
                  indent: 30,
                  endIndent: 30,
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Information personnelles",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              subtitle: Text(
                                widget.phone,
                                style: TextStyle(fontSize: 15),
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 10, 0),
                              leading: Icon(Icons.phone, size: 26),
                              title: Text(
                                "Téléphone",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            ListTile(
                              subtitle: Text(
                                widget.email,
                                style: TextStyle(fontSize: 15),
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 10, 10),
                              leading: Icon(Icons.email, size: 26),
                              title: Text(
                                "Adresse e-mail",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            ListTile(
                              subtitle: Text(
                                widget.address,
                                style: TextStyle(fontSize: 15),
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 10, 15),
                              leading: Icon(Icons.home, size: 26),
                              title: Text(
                                "Adresse",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
