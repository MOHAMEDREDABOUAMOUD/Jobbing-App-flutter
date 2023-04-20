// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/models/worker.dart';
import 'package:signin_signup/pages/profile.dart';

class Service extends StatefulWidget {
  final String name;
  final String emailMe;
  const Service({super.key, required this.name, required this.emailMe});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  List<Worker> prestatairess = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getWorkrs();
    });
  }

  Future<void> getWorkrs() async {
    List<Worker> w = await DAO.getWorkers(widget.name) as List<Worker>;
    setState(() {
      prestatairess = w;
    });
  }

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
            child: Column(
              children: [
                SizedBox(height: 50),
                Text("Trouver le prestataire idéal pour vos attentes"),
                SizedBox(height: 50),
                ListView.builder(
                  itemCount: prestatairess.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WorkerP(
                                  sender: widget.emailMe,
                                  receiver:
                                      prestatairess.elementAt(index).email,
                                )));
                      },
                      child: Card(
                        //margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: ListTile(
                          minVerticalPadding: 30,
                          minLeadingWidth: 10,
                          title: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(prestatairess.elementAt(index).name),
                              SizedBox(width: 20),
                              RatingBar.builder(
                                  ignoreGestures: true,
                                  itemSize: 18,
                                  initialRating:
                                      prestatairess.elementAt(index).rate,
                                  itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                  onRatingUpdate: (rating) {}),
                            ],
                          ),
                          subtitle:
                              Text(prestatairess.elementAt(index).description),
                          leading: CircleAvatar(
                            radius: 30,
                            child: CircleAvatar(
                              backgroundImage: prestatairess
                                          .elementAt(index)
                                          .imgUrl !=
                                      ""
                                  ? NetworkImage(
                                      prestatairess.elementAt(index).imgUrl)
                                  : NetworkImage(
                                      'https://www.w3schools.com/howto/img_avatar.png'),
                              radius: 30,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                ),
              ],
            ),
          )),
    );
  }
}
