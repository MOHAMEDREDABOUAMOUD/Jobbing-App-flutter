// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/services/business.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final EmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your email and we will send you a password reset link",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: EmailController,
              hintText: 'E-mail',
              ObscureText: false,
              type: TextInputType.emailAddress,
              icon: Icon(Icons.email),
              lines: 1,
            ),
            const SizedBox(height: 25),
            MyButton(
              Ontap: () async =>
                  await services.PasswordReset(context, EmailController.text),
              name: 'Reset Password',
            ),
          ],
        ),
      ),
    );
  }
}
