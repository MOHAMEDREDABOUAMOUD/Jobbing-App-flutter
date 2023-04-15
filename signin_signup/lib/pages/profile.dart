// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/services/business.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:signin_signup/models/comment.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'chat_page.dart';
//import 'comment.dart';

class WorkerP extends StatefulWidget {
  //const WorkerP({Key? key}) : super(key: key);
  final String sender, receiver;
  const WorkerP({super.key, required this.sender, required this.receiver});

  @override
  State<WorkerP> createState() => _WorkerPState();
}

class _WorkerPState extends State<WorkerP> {
  //List<String> comments = [];
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();
  String collectionS = "", collectionR = "";
  double nbStar = 0;
  String receiver_image = "";
  String receiver_name = "";
  String receiver_job = "";
  String receiver_tel = "";
  double receiver_rate = 0;
  int receiver_nbRates = 0;
  String receiver_description = "";
  String sender_image = "";
  String sender_name = "";

  @override
  void initState() {
    super.initState();
    //print('${widget.sender} / ${widget.receiver}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCollections();
      await getsenderInformations();
      await getReceiverInformations();
      await fillComments();
    });
  }

  Future<void> fillComments() async {
    List<Comment> res =
        await DAO.fillComments(widget.receiver) as List<Comment>;
    setState(() {
      comments = res;
    });
  }

  Future<void> getsenderInformations() async {
    Map<String, String> res = {};
    res = await DAO.getSenderInformationsForProfile(collectionS, widget.sender)
        as Map<String, String>;
    sender_name = res['sender_name']!;
    setState(
      () {
        sender_image = res["sender_image"]!;
      },
    );
  }

  Future<void> getReceiverInformations() async {
    Map<String, dynamic> res = {};
    res = await DAO.getReceiverInformations(collectionR, widget.receiver)
        as Map<String, dynamic>;
    setState(() {
      receiver_name = res["receiver_name"];
      if (collectionR == "prestataire") {
        receiver_description = res["receiver_description"];
        receiver_job = res["receiver_job"];
        receiver_rate = res["receiver_rate"];
        receiver_nbRates = res["receiver_nbRates"];
      }
      receiver_tel = res["receiver_tel"];
      receiver_image = res["receiver_image"];
    });
  }

  Future<void> getCollections() async {
    collectionS = await DAO.getType(widget.sender) as String;
    collectionR = await DAO.getType(widget.receiver) as String;
  }

  void addItemToList(double rate) {
    setState(() {
      comments.add(
        Comment(
            name: sender_name,
            comment: commentController.text,
            imageUrl: sender_image,
            rate: rate),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          //appBar
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
                  //picture
                  CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 113,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: receiver_image != ""
                            ? NetworkImage(receiver_image)
                            : NetworkImage(
                                'https://www.w3schools.com/howto/img_avatar.png'), //////////////////////
                        radius: 110,
                      )),
                  SizedBox(height: 20),
                  //name
                  Text(
                    receiver_name,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //service
                      Text(
                        receiver_job,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          //color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(width: 20),
                      //call button
                      IconButton(
                        onPressed: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                              receiver_tel);
                        },
                        icon: Icon(
                          Icons.call,
                          size: 27,
                          color: Color.fromARGB(255, 245, 147, 0),
                        ),
                      ),
                      //chat button
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ChatScreen(
                                sender: widget.sender,
                                receiver: widget.receiver,
                              ),
                            ),
                          );
                        },
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
                      //star
                      Icon(
                        Icons.star,
                        color: Colors.yellowAccent[700],
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      //avg rate of this user
                      Text(
                        receiver_rate.toString(),
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      SizedBox(width: 10),
                      //number of rates
                      Text(
                        '( ${receiver_nbRates.toString()} )',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 50),
                  //line
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
                        //description title
                        Text(
                          "Déscription",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        //description
                        Text(
                          receiver_description,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(height: 20),
                        //commentaire titre
                        Text(
                          "Avis et commentaires",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        //les commentaires
                        Container(
                          height: 300,
                          child: ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Text(comments[index].name),
                                      SizedBox(width: 20),
                                      RatingBar.builder(
                                          ignoreGestures: true,
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
                                      backgroundImage: NetworkImage(
                                          comments[index].imageUrl),
                                      radius: 20,
                                    ),
                                  ),
                                ),
                              );
                            },
                            shrinkWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  //rate title
                  Text(
                    "Rate ( $receiver_name )",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  //stars
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
                    //textfield of comments
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
                          onPressed: () async {
                            addItemToList(nbStar);
                            await services.addComment(
                                collectionR,
                                widget.sender,
                                widget.receiver,
                                nbStar,
                                commentController.text,
                                sender_name,
                                sender_image);
                          },
                          icon: Icon(Icons.rate_review),
                        ),
                        suffixIconColor: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //boutton demander
                  collectionS == "client" && collectionR == "prestataire"
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 245, 147, 0)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10))),
                          child: Text(
                            "Demander",
                            style: TextStyle(fontSize: 25),
                          ),
                        )
                      : Text(''),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )),
    );
  }
}
