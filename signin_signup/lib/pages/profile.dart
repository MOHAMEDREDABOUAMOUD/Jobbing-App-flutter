// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:signin_signup/services/comment.dart';
//import 'comment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Worker(),
    );
  }
}

class Worker extends StatefulWidget {
  //const Worker({Key? key}) : super(key: key);
  const Worker({super.key});

  @override
  State<Worker> createState() => _WorkerState();
}

class _WorkerState extends State<Worker> {
  //List<String> comments = [];
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  void addItemToList(double rate) {
    setState(() {
      comments.add(
        Comment(
            name: "Houda",
            comment: commentController.text,
            imageUrl: "lib/images/fb.jpg",
            rate: rate),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double nbStar = 0;
    var url_image;
    var user_name;
    var user_last_name;
    var job;
    var tel;
    var rate;
    var nb_rates;
    var description;
    rate = "4,53";
    url_image = "lib/images/fb.jpg";
    user_name = "Houda";
    user_last_name = "Bouzoubaa";
    job = "Babysitter";
    tel = 'tel:+212 68446882';
    nb_rates = "(200 avis)";
    description =
        "Maman de deux filles (23 et 20 ans), j'ai gardé des enfants avec expérience de plus de 9 ans. Sérieuse et ponctuelle. N'hésitez pas à me contacter si vous avez des questions. Merci";
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.grey[700],
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 113,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(url_image),
                        radius: 110,
                      )),
                  SizedBox(height: 20),
                  Text(
                    "$user_name $user_last_name",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        job,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          //color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          launch(tel);
                        },
                        icon: Icon(
                          Icons.call,
                          size: 27,
                          color: Color.fromARGB(255, 245, 147, 0),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.chat,
                          size: 27,
                          color: Color.fromARGB(255, 245, 147, 0),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellowAccent[700],
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      Text(
                        rate,
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        nb_rates,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 50),
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
                          "Déscription",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          description,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Avis et commentaires",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text("Houda"),
                                    SizedBox(width: 20),
                                    RatingBar.builder(
                                        itemSize: 20,
                                        initialRating: comments[index].rate,
                                        itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        onRatingUpdate: (rating) {}),
                                  ],
                                ),
                                subtitle: Text(comments[index].comment),
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(comments[index].imageUrl),
                                    radius: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Rate $user_name",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  RatingBar.builder(
                    minRating: 0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      nbStar = rating;
                      print(rating);
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 350,
                    //color: Colors.white,
                    child: TextField(
                      controller: commentController,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type your review",
                        hintStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          //borderSide: BorderSide(color: Colors.green, width: 3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            addItemToList(nbStar);
                          },
                          icon: Icon(Icons.rate_review),
                        ),
                        suffixIconColor: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),

                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 245, 147, 0)),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10))),
                    child: Text(
                      "Demander",
                      style: TextStyle(fontSize: 25),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
