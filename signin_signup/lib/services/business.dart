// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:signin_signup/pages/home_page.dart';
import '../DAL/dao.dart';

class services {
  static Future<void> PasswordReset(var contextt, String email) async {
    try {
      await DAO.resetPass(email);
      showDialog(
        context: contextt,
        builder: (context) {
          return AlertDialog(
            content: Text("Password reset link sent! Check email"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: contextt,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  static showErrorMessag(var contextt) {
    showDialog(
        context: contextt,
        builder: (context) {
          return const AlertDialog(
            title: Text("Password don't match"),
          );
        });
  }

  static Future<void> SignUserUp(
      bool google,
      var contextt,
      String email,
      String pass,
      String repass,
      String name,
      String phone,
      String service,
      String description,
      var cardFront,
      var cardBack) async {
    if (pass == repass) {
      //show loading circle
      showDialog(
          context: contextt,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      //signup
      if (google == false) {
        try {
          DAO.createAcc(email, pass);
        } catch (e) {}
      }
      //add user infos to cloud
      await DAO.addUserinformations(
          name, email, phone, pass, service, description);
      await DAO.addUserIdentity(email, cardFront, cardBack);
      Navigator.pop(contextt);
      //Navigator.pop(context);
    } else {
      showErrorMessag(contextt);
    }
  }

  static Future<bool> checkIdentity(img.Image image) async {
    // Convert the image to grayscale
    img.Image grayscaleImage = img.grayscale(image);

    // Define the Laplacian filter
    List<num> laplacianFilter = [0, 1, 0, 1, -4, 1, 0, 1, 0];

    // Apply the Laplacian filter to the grayscale image
    img.Image filteredImage =
        img.convolution(grayscaleImage, filter: laplacianFilter);

    // Compute the variance of the Laplacian
    double mean = 0.0;
    int count = 0;
    for (int y = 0; y < filteredImage.height; y++) {
      for (int x = 0; x < filteredImage.width; x++) {
        var pixel = filteredImage.getPixel(x, y);
        int gray = img.getLuminance(pixel).round();
        mean += gray;
        count++;
      }
    }
    mean /= count;

    double variance = 0.0;
    for (int y = 0; y < filteredImage.height; y++) {
      for (int x = 0; x < filteredImage.width; x++) {
        var pixel = filteredImage.getPixel(x, y);
        int gray = img.getLuminance(pixel).round();
        variance += pow(gray - mean, 2);
      }
    }
    variance /= count - 1;
    print(
        '$variance****************************************************************************');
    // Determine if the image is clear or not based on the variance of the Laplacian
    if (variance < 50) {
      return false;
    } else {
      return true;
    }
  }

  static void wrongEmailMessage(var contextt) {
    showDialog(
        context: contextt,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Email"),
          );
        });
  }

  static void wrongPasswordMessage(var contextt) {
    showDialog(
        context: contextt,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect password"),
          );
        });
  }

  static Future<void> signUserIn(
      var contextt, String email, String pass) async {
    //show loading circle
    showDialog(
        context: contextt,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //signin
    try {
      DAO.signIn(email, pass);
      //await getUserInformations();
      Navigator.pop(contextt);
      Navigator.push(
        contextt,
        MaterialPageRoute(
          builder: (context) => HomePage(
            emailMe: email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      //Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage(contextt);
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage(contextt);
      }
    }
  }

  static Future<void> addComment(
      String collectionR,
      String sender,
      String receiver,
      double nbStar,
      String comment,
      String nameS,
      var imageS) async {
    await DAO.addComment(
        collectionR, sender, receiver, nbStar, comment, nameS, imageS);
  }

  static void showErrorMessagPass(var contextt) {
    showDialog(
        context: contextt,
        builder: (context) {
          return const AlertDialog(
            title: Text("Password don't match"),
          );
        });
  }

  static SignUserUpC(
      bool google,
      var contextt,
      String email,
      String pass,
      String repass,
      String name,
      String phone,
      var profile,
      String profileName) async {
    if (pass == repass) {
      //show loading circle
      showDialog(
          context: contextt,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      //signup
      if (google == false) {
        try {
          await DAO.createAcc(email, pass);
        } catch (e) {}
      }
      //add user infos to cloud
      addUserinformations(email, pass, name, phone);
      addUserImage(google, email, profile, profileName);
      Navigator.pop(contextt);
      Navigator.pop(contextt);
    } else {
      showErrorMessagPass(contextt);
    }
  }

  static Future<void> addUserinformations(
      String email, String pass, String name, String phone) async {
    await DAO.addUserinformationsC(name, email, phone, pass);
  }

  static Future<void> addUserImage(
      bool google, String email, var profile, String profileName) async {
    await DAO.addUserImage(google, email, profile, profileName);
  }
}
