// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'service.dart';

class Grid extends StatefulWidget {
  final String emailMe;
  const Grid({super.key, required this.emailMe});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final List<Map<String, dynamic>> services = [
    {
      "image": "lib/images/img/Plomberie.png",
      "title": "Plomberie",
    },
    {
      "image": "lib/images/img/Renovation.png",
      "title": "Rénovation",
    },
    {
      "image": "lib/images/img/Babysitting.png",
      "title": "Babysitting",
    },
    {
      "image": "lib/images/img/Electricite.png",
      "title": "Eléctricité",
    },
    {
      "image": "lib/images/img/Menage.png",
      "title": "Ménage",
    },
    {
      "image": "lib/images/img/Jardinage.png",
      "title": "Jardinage",
    },
    {
      "image": "lib/images/img/Demenagement.png",
      "title": "Démenagement",
    },
    {
      "image": "lib/images/img/Informatique.png",
      "title": "Informatique",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20, 40, 30, 10),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 60,
      ),
      itemCount: services.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            print(
                "${widget.emailMe}*************************************************");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Service(
                    emailMe: widget.emailMe,
                    name: services.elementAt(index)['title'])));
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:
                    AssetImage("${services.elementAt(index)['image']}"),
                radius: 50,
              ),
              SizedBox(height: 20),
              Text(
                "${services.elementAt(index)['title']}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
