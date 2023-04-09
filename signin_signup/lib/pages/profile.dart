// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:signin_signup/models/comment.dart';

import 'chat_page.dart';
//import 'comment.dart';

class Worker extends StatefulWidget {
  //const Worker({Key? key}) : super(key: key);
  final String sender, receiver;
  const Worker({super.key, required this.sender, required this.receiver});

  @override
  State<Worker> createState() => _WorkerState();
}

class _WorkerState extends State<Worker> {
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
    CollectionReference info =
        FirebaseFirestore.instance.collection('commentaire');
    var userBase =
        await info.where("receiver", isEqualTo: widget.receiver).get();
    if (userBase.docs.isNotEmpty) {
      for (var i = 0; i < userBase.docs.length; i++) {
        setState(() {
          comments.add(Comment(
              name: userBase.docs[i]['senderName'],
              comment: userBase.docs[i]['text'],
              imageUrl: userBase.docs[i]['senderImage'],
              rate: userBase.docs[i]['rate']));
        });
      }
    }
  }

  Future<void> getsenderInformations() async {
    CollectionReference info =
        FirebaseFirestore.instance.collection(collectionS);
    var userBase = await info.where("email", isEqualTo: widget.sender).get();
    if (userBase.docs.isNotEmpty) {
      sender_name = userBase.docs[0]['name'];
    }
    await FirebaseStorage.instance
        .ref('profiles/${widget.sender}')
        .getDownloadURL()
        .then(
      (value) {
        setState(
          () {
            sender_image = value;
          },
        );
      },
    );
  }

  Future<void> getReceiverInformations() async {
    CollectionReference info =
        FirebaseFirestore.instance.collection(collectionR);
    var userBase = await info.where("email", isEqualTo: widget.receiver).get();
    if (userBase.docs.isNotEmpty) {
      receiver_name = userBase.docs[0]['name'];
      if (collectionR == "prestataire") {
        receiver_description = userBase.docs[0]['description'];
        receiver_job = userBase.docs[0]['service'];
        double roundedNumber = double.parse(
            (userBase.docs[0]['rate'] / userBase.docs[0]['nbRates'])
                .toStringAsFixed(1));
        receiver_rate = roundedNumber;
        receiver_nbRates = userBase.docs[0]['nbRates'];
      }
      receiver_tel = userBase.docs[0]['phone'];
    }
    print('profiles/${widget.receiver}');
    await FirebaseStorage.instance
        .ref('profiles/${widget.receiver}')
        .getDownloadURL()
        .then(
      (value) {
        setState(
          () {
            receiver_image = value;
          },
        );
      },
    );
  }

  Future<void> getCollections() async {
    print(
        '${widget.sender} / ${widget.receiver}**************************************');
    final info = await FirebaseFirestore.instance.collection('client');
    final query = await info.where('email', isEqualTo: widget.sender);
    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      collectionS = "client";
    } else {
      collectionS = "prestataire";
    }

    final info1 = await FirebaseFirestore.instance.collection('client');
    final query1 = await info1.where('email', isEqualTo: widget.receiver);
    final snapshot1 = await query1.get();

    if (snapshot1.docs.isNotEmpty) {
      collectionR = "client";
    } else {
      collectionR = "prestataire";
    }
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

  void addComment() async {
    final info = await FirebaseFirestore.instance.collection(collectionR);
    final query = await info.where('email', isEqualTo: widget.receiver);
    final snapshot = await query.get();
    int sur = 1;
    if (snapshot.docs[0]['rate'] == 0) {
      sur = 1;
    } else {
      sur = 2;
    }
    await snapshot.docs[0].reference.update({
      'nbRates': snapshot.docs[0]['nbRates'] + 1,
      'rate': snapshot.docs[0]['rate'] + nbStar,
    });
    CollectionReference colRef =
        FirebaseFirestore.instance.collection('commentaire');
    colRef.add({
      'receiver': widget.receiver,
      'sender': widget.sender,
      'text': commentController.text,
      'time': FieldValue.serverTimestamp(),
      'rate': nbStar,
      'senderName': sender_name,
      'senderImage': sender_image
    });
  }

  @override
  Widget build(BuildContext context) {
    // url_image = "lib/images/fb.jpg";
    // user_name = "Houda Bouzoubaa";
    // job = "Babysitter";
    // tel = 'tel:+212 68446882';
    // description =
    //     "Maman de deux filles (23 et 20 ans), j'ai gardé des enfants avec expérience de plus de 9 ans. Sérieuse et ponctuelle. N'hésitez pas à me contacter si vous avez des questions. Merci";
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
                    "$receiver_name",
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
                        onPressed: () {
                          launch(receiver_tel);
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
                        ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(sender_name),
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
                                        NetworkImage(comments[index].imageUrl),
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
                          onPressed: () {
                            addItemToList(nbStar);
                            addComment();
                          },
                          icon: Icon(Icons.rate_review),
                        ),
                        suffixIconColor: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),

                  //boutton demander
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
