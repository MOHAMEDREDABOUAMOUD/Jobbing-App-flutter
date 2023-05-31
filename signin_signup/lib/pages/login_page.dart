// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/DAL/dao.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:signin_signup/components/my_textfield.dart';
import 'package:signin_signup/components/square_tile.dart';
import 'package:signin_signup/pages/home_page.dart';
import 'package:signin_signup/pages/messagerie.dart';
import 'package:signin_signup/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:signin_signup/services/business.dart';

import '../components/passTextField.dart';
import 'forgotPassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String Name = "";
  String phone = "";
  String description = "";
  String urlProfile = "";
  String profile = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),

                Text(
                  "Smart Jobbing",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                //welcome back,you've been missed!
                Text(
                  'Content de vous revoir !',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 60),

                //Email textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Adresse e-mail',
                  ObscureText: false,
                  type: TextInputType.emailAddress,
                  icon: Icon(Icons.email),
                  lines: 1,
                ),

                const SizedBox(height: 10),

                //password textfield

                PassTextField(
                  controller: passwordController,
                  hintText: 'Mot de passe',
                ),

                const SizedBox(height: 25),

                //forgot password

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ForgotPassword();
                            },
                          ));
                        },
                        child: Text(
                          'Mot de passe oublié?',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //signin button

                MyButton(
                  Ontap: () async {
                    try {
                      await services.signUserIn(context,
                          usernameController.text, passwordController.text);
                    } catch (e) {}
                  },
                  name: 'Se connecter',
                ),

                //or continue with

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 100,
                          thickness: 0.5,
                          color: Colors.grey[700],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Etes-vous un client? Continuez avec Google',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 100,
                          thickness: 0.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                //google sign in

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(
                      imagePath: 'lib/images/google.png',
                      OnTap: () async {
                        await AuthService().signInWithGoogle();
                        Map<String, String> result = AuthService.Result();
                        await services.SignUserUpC(
                            true,
                            context,
                            result['email']!,
                            "",
                            "",
                            result['name']!,
                            "",
                            result['profile']!,
                            "");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Main(
                              email: result['email']!,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                //not a membre? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore membre?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      // ignore: sort_child_properties_last
                      child: Text(
                        'Creer un compte',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
