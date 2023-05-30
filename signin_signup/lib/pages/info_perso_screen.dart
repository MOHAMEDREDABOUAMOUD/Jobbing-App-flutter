// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/pages/payment_screen.dart';

class InfoScreen extends StatefulWidget {
  final String client;
  final String prestataire;
  const InfoScreen({Key? key, required this.client, required this.prestataire})
      : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  DateTime? selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = DateFormat("hh:mm a")
            .format(DateTime(2000, 1, 1, pickedTime.hour, pickedTime.minute));
      });
    }
  }

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
      });
    }
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
    timeController.text = "";
  }

  Future<void> addDemand() async {
    await DAO.addDemand(widget.client, widget.prestataire, dateController.text,
        timeController.text, descriptionController.text);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 90),
                Text(
                  "Informations sur la demande",
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 60),
                TextFormField(
                  controller: dateController,
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
                        "Date", //show to the user what to type in that text field
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.calendar_today),
                    prefixIconColor: Colors.grey[600],
                  ),
                  readOnly: true,
                  onTap: _showDatePicker,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: timeController,
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
                        "Heure", //show to the user what to type in that text field
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.alarm),
                    prefixIconColor: Colors.grey[600],
                  ),
                  readOnly: true,
                  onTap: _showTimePicker,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  minLines: 1,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
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
                        "Description", //show to the user what to type in that text field
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          //hna areda dir dikchi f database w 3ad ana ndwzk l page d payment w page payment madirhach f database khliha hakak
                          await addDemand();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                        emailMe: widget.client,
                                      )));
                        },
                        child: Icon(Icons.navigate_next),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
