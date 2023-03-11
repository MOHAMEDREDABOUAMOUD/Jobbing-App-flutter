// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:signin_signup/components/my_button.dart';
import 'package:signin_signup/components/square_tile.dart';

import '../components/my_textfield.dart';
import '../components/passTextField.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  TextEditingController passcontroller1 = TextEditingController();
  TextEditingController passcontroller2 = TextEditingController();

  SignUserUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Text(
            'SignUp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/");
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                //Welcome to our app

                SizedBox(height: 20),
                Text(
                  'Welcome to our App!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 110),
                  child: Divider(
                    height: 10,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 20),

                //text fields

                MyTextField(
                  controller: null,
                  hintText: 'User',
                  ObscureText: false,
                  type: TextInputType.name,
                  icon: Icon(Icons.person),
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: null,
                  hintText: 'Email',
                  ObscureText: false,
                  type: TextInputType.emailAddress,
                  icon: Icon(Icons.email),
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: null,
                  hintText: 'Phone number',
                  ObscureText: false,
                  type: TextInputType.phone,
                  icon: Icon(Icons.phone),
                ),
                SizedBox(height: 20),
                PassTextField(
                  controller: passcontroller1,
                  hintText: 'password',
                ),
                SizedBox(height: 20),
                PassTextField(
                  controller: passcontroller2,
                  hintText: 'Confirm password',
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: null,
                  hintText: 'Description',
                  ObscureText: false,
                  type: TextInputType.multiline,
                  icon: Icon(Icons.description),
                ),
                SizedBox(height: 20),

                //button register
                MyButton(
                  Ontap: (SignUserUp),
                  name: 'Sign Up',
                ),
                SizedBox(height: 20),
                //or

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 10,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Or with',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 10,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                //google and apple logo

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SquareTile(imagePath: 'lib/images/google.png'),
                    SizedBox(
                      height: 20,
                      width: 20,
                    ),
                    SquareTile(imagePath: 'lib/images/apple.png'),
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
