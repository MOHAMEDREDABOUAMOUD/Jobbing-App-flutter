// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Apropos extends StatefulWidget {
  const Apropos({super.key});

  @override
  State<Apropos> createState() => _AproposState();
}

class _AproposState extends State<Apropos> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
        child: Container(
          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Qui sommes-nous ?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
              ),
              SizedBox(height: 50),
              Image.asset("lib/images/img/service.png", height: 120),
              SizedBox(height: 30),
              Text(
                "Les spécialistes des services à domicile.\nChez Smart Jobbing, notre mission est de faciliter la vie des gens en connectant les particuliers et les prestataires de services de manière simple et rapide.\nQue vous soyez à la recherche d'un service ou que vous souhaitiez proposer vos compétences, notre application est là pour vous aider. ",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  wordSpacing: 2,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ));
  }
}
