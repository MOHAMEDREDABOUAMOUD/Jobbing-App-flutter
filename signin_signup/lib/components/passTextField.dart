// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'dart:async';

class PassTextField extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  String hintText = "";
  bool ObscureText = true;

  PassTextField({super.key, required this.controller, required this.hintText});

  @override
  State<PassTextField> createState() => _PassTextFieldState(
        controller: controller,
        hintText: hintText,
      );
}

class _PassTextFieldState extends State<PassTextField> {
  TextEditingController controller = TextEditingController();
  String hintText = "";
  bool ObscureText = true;
  _PassTextFieldState({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: controller, //control what the user type in the textfield
        obscureText:
            ObscureText, //hide the characters when the user type the password
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText, //show to the user what to type in that text field
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: IconButton(
            icon: ObscureText
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                ObscureText = !ObscureText;
              });
            },
          ),
          prefixIcon: Icon(Icons.password),
        ),
      ),
    );
  }
}
