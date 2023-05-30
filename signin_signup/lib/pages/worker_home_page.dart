// ignore_for_file: prefer_const_constructors, unnecessary_cast, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:signin_signup/models/worker.dart';
import 'package:signin_signup/pages/aboutUs.dart';
import 'package:signin_signup/pages/clientProfile.dart';
import 'package:signin_signup/pages/grid.dart';
import 'package:signin_signup/pages/messagerie.dart';
import 'package:signin_signup/pages/profile.dart';
import 'package:signin_signup/pages/settings.dart';
import 'package:signin_signup/pages/statistics.dart';
import 'package:signin_signup/pages/AppStatistics.dart';

import '../models/demande.dart';

class WorkerMain extends StatefulWidget {
  final String email;
  const WorkerMain({super.key, required this.email});

  @override
  State<WorkerMain> createState() => _WorkerMainState();
}

class _WorkerMainState extends State<WorkerMain> {
  List<Demande> demandes = [];
  late final PageController pageController;
  String userName = "";
  String imageUrl = "";
  String phonee = "";
  String collection = "";
  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getsenderInformations();
    });
    super.initState();
  }

  Future<void> getsenderInformations() async {
    Map<String, String> res = {};
    String res1 = await DAO.getType(widget.email) as String;
    if (res1 != "") {
      setState(() {
        collection = res1;
      });
      res = await DAO.getSenderInformationsForProfile(collection, widget.email)
          as Map<String, String>;
      if (res.length > 0) {
        setState(
          () {
            userName = res['sender_name']!;
            imageUrl = res["sender_image"]!;
            phonee = res['phone']!;
          },
        );
      }
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(150, 158, 158, 158),
                ),
                accountName: Text(
                  userName,
                  style: TextStyle(fontSize: 25),
                ),
                accountEmail: Text(
                  widget.email,
                  style: TextStyle(fontSize: 15),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  child: CircleAvatar(
                    backgroundImage: imageUrl != ""
                        ? NetworkImage(imageUrl)
                        : NetworkImage(
                            'https://www.w3schools.com/howto/img_avatar.png'),
                    radius: 100,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                leading: Icon(Icons.account_circle, size: 30),
                title: Text(
                  "Compte",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  if (collection == "client") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ClientProfile(
                              name: userName,
                              urlImage: imageUrl,
                              phone: phonee,
                              email: widget.email,
                              address: "Fes",
                            )));
                  } else if (collection == "prestataire") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WorkerP(
                              sender: widget.email,
                              receiver: widget.email,
                            )));
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                leading: Icon(Icons.chat, size: 30),
                title: Text(
                  "Messagerie",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Messagerie(
                            emailMe: widget.email,
                          )));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                leading: Icon(Icons.settings, size: 30),
                title: Text(
                  "Paramètres",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings_Screen()),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                leading: Icon(Icons.bar_chart_rounded, size: 30),
                title: Text(
                  "Statistiques",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  if (collection == "client") {
                    Navigator.of(context).push(
                        //MaterialPageRoute(builder: (context) => Statistics())
                        MaterialPageRoute(
                            builder: (context) => AppStatistics(
                                  email: widget.email,
                                )));
                  } else if (collection == "prestataire") {
                    Navigator.of(context).push(
                        //MaterialPageRoute(builder: (context) => Statistics())
                        MaterialPageRoute(
                            builder: (context) => Statistics(
                                  email: widget.email,
                                )));
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                leading: Icon(Icons.info_outlined, size: 30),
                title: Text(
                  "A propos",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Apropos()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(190, 80, 0, 0),
                leading: Icon(
                  Icons.logout,
                  size: 25,
                  color: Colors.red[600],
                ),
                title: Text(
                  "Exit",
                  style: TextStyle(fontSize: 20, color: Colors.red[600]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
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
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Mes demandes",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 139, 139, 139)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              height: 600,
              child: ListView.builder(
                itemCount: 3, //demandes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  'https://www.w3schools.com/howto/img_avatar.png'), //demandes[index].imageClient),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bouzoubaa",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ), //demandes[index].nomClient),
                                Text(
                                    "0604963633"), //demandes[index].description),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date : 11/10/2023", //+ demandes[index].date,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Heure : 12:30", //+ demandes[index].heure,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Frontend Application de jobbing", //demandes[index].description,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 40),
                              //Accepter Rejetter
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 90,
                                        height: 40,
                                        //padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 25),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Text(
                                          "Accepter",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 90,
                                        height: 40,
                                        //padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 25),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Text(
                                          "Rejetter",
                                          style: TextStyle(
                                              color: Colors.red[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]),
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
