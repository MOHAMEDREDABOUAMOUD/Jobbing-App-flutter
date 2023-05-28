// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool ObscureText;
  final Widget? icon;
  final TextInputType type;
  final int lines;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.ObscureText,
    required this.icon,
    required this.type,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: TextField(
        maxLines: lines,
        keyboardType: type,
        controller: controller, //control what the user type in the textfield
        obscureText:
            ObscureText, //hide the characters when the user type the password
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
          hintText: hintText, //show to the user what to type in that text field
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: icon,
          prefixIconColor: Colors.grey[600],
        ),
      ),
    );
  }
}
