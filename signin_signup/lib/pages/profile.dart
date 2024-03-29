// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/pages/info_perso_screen.dart';
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
  double heightOfComments = 300;
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
    print(
        '${widget.sender} / ${widget.receiver}************************************');
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
    if (comments.length <= 4) {
      setState(() {
        heightOfComments = comments.length * 75;
      });
    }
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
          //appBar
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
              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //picture
                  CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 73,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: receiver_image != ""
                            ? NetworkImage(receiver_image)
                            : NetworkImage(
                                'https://www.w3schools.com/howto/img_avatar.png'), //////////////////////
                        radius: 70,
                      )),
                  SizedBox(height: 10),
                  //name
                  Text(
                    receiver_name,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //service
                      Text(
                        receiver_job,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 20),
                      //call button
                      sender_name != receiver_name
                          ? IconButton(
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber(
                                    receiver_tel);
                              },
                              icon: Icon(
                                Icons.call,
                                size: 27,
                                color: Colors.amber,
                              ),
                            )
                          : Text(""),
                      //chat button
                      sender_name != receiver_name
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        ChatScreen(
                                      sender: widget.sender,
                                      receiver: widget.receiver,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.chat,
                                size: 27,
                                color: Colors.amber,
                              ),
                            )
                          : Text("")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //star
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      //avg rate of this user
                      Text(
                        receiver_rate.toString(),
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 10),
                      //number of rates
                      Text(
                        '(${receiver_nbRates.toString() + " avis"})',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
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
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        //description
                        Text(
                          receiver_description,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        //commentaire titre
                        Text(
                          "Avis et commentaires",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 20),
                        //les commentaires
                        Container(
                          height: heightOfComments,
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
                                          itemSize: 15,
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
                  sender_name == receiver_name
                      ? Column()
                      : Column(
                          children: [
                            //rate title
                            Text(
                              "Notez ( $receiver_name )",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 10),
                            //stars
                            RatingBar.builder(
                              itemSize: 26,
                              minRating: 0,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
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
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.amber,
                                      )),
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  filled: true,
                                  hintText:
                                      "Commentaire", //show to the user what to type in that text field
                                  hintStyle: TextStyle(color: Colors.grey),

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

                                  suffixIconColor: Colors.grey[700],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            //boutton demander
                            collectionS == "client" &&
                                    collectionR == "prestataire"
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => InfoScreen(
                                                    client: widget.sender,
                                                    prestataire:
                                                        widget.receiver,
                                                  )));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.amber),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 10))),
                                    child: Text(
                                      "Demander",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )
                                : Text(''),
                            SizedBox(height: 20),
                          ],
                        ),
                ],
              ),
            ),
          )),
    );
  }
}
