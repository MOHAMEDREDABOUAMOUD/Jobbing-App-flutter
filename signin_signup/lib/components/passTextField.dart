// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'dart:async';

class PassTextField extends StatefulWidget {
  final controller;
  String hintText = "";
  bool ObscureText = true;

  PassTextField({super.key, required this.controller, required this.hintText});

  @override
  // ignore: no_logic_in_create_state
  State<PassTextField> createState() => _PassTextFieldState(
        controllerr: controller,
        hintText: hintText,
      );
}

class _PassTextFieldState extends State<PassTextField> {
  final controllerr;
  String hintText = "";
  bool ObscureText = true;
  _PassTextFieldState({required this.controllerr, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: TextField(
        controller: controllerr, //control what the user type in the textfield
        obscureText:
            ObscureText, //hide the characters when the user type the password
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          hintText: hintText, //show to the user what to type in that text field
          hintStyle: TextStyle(color: Colors.grey),
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
          suffixIconColor: Colors.grey[600],
          prefixIcon: Icon(Icons.lock),
          prefixIconColor: Colors.grey[600],
        ),
      ),
    );
  }
}
