import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/components/my_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  void saveReportToFirestore(String email, String report) {
    CollectionReference reportsCollection =
        FirebaseFirestore.instance.collection('reports');

    reportsCollection.add({
      'email': email,
      'report': report,
      'timestamp': DateTime.now(),
    }).then((value) {
      // Report saved successfully
      print('Report saved to Firestore');
      // You can show a success message or navigate to another screen here
    }).catchError((error) {
      // An error occurred while saving the report
      print('Error saving report: $error');
      // You can show an error message here
    });
  }

  bool _isVisible = false;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _reportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        // Wrap the Column widget with SingleChildScrollView
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            children: [
              Text(
                "Signaler um problème",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Votre email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller:
                      _reportController, // Add the controller to the TextFormField
                  minLines: 5,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Votre problème',
                    hintStyle: TextStyle(),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              //button register
              MyButton(
                Ontap: (() async {
                  String email = _emailController.text;
                  String report = _reportController.text;
                  saveReportToFirestore(email, report);
                }),
                name: "Report",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
