// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool ObscureText;
  final Widget? icon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.ObscureText,
    required this.icon,
  });

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
          prefixIcon: icon,
        ),
      ),
    );
  }
}
