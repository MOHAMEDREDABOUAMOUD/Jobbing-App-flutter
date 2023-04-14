import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:signin_signup/models/comment.dart';
import 'package:http/http.dart' as http;

class DAO {
  static Future<String> getType(String email) async {
    final info = await FirebaseFirestore.instance.collection('client');
    final query = await info.where('email', isEqualTo: email);
    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      return "client";
    } else {
      return "prestataire";
    }
  }

  static Future<Map<String, String>> getReceiverInfo(
      String collectionR, String email) async {
    Map<String, String> res = new Map();
    var userBase = await FirebaseFirestore.instance
        .collection(collectionR)
        .where("email", isEqualTo: email)
        .get();
    res.addAll({"name": userBase.docs[0]['name']});
    await FirebaseStorage.instance
        .ref('profiles')
        .child(email)
        .getDownloadURL()
        .then(
      (value) {
        res.addAll({"profileR": value});
      },
    );
    return res;
  }

  static Future<String> getSenderInfo(String collectionS, String email) async {
    var userBase = await FirebaseFirestore.instance
        .collection(collectionS)
        .where("email", isEqualTo: email)
        .get();
    if (userBase.docs.isNotEmpty) {
      return userBase.docs[0]['name'];
    }
    return "";
  }

  static Future<void> resetPass(String emaill) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emaill);
  }

  static Future<void> createAcc(String email, String pass) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
  }

  static Future<void> addUserIdentity(
      String email, var cardFront, var cardBack) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage
          .ref('profiles/${email}-front')
          .putFile(cardFront); //file name
      await storage.ref('profiles/${email}-back').putFile(cardBack); //file name
    } catch (e) {}
  }

  static Future<void> addUserinformations(String name, String email,
      String phone, String pass, String service, String description) async {
    await FirebaseFirestore.instance.collection("prestataire").add({
      'name': name,
      'email': email,
      'phone': phone,
      'password': pass,
      'latitude': 0,
      'longitude': 0,
      'service': service,
      'description': description,
      'rate': 0.0,
      'nbRates': 0
    });
  }

  static Future<void> addUserinformationsC(
      String name, String email, String phone, String pass) async {
    await FirebaseFirestore.instance.collection("client").add({
      'name': name,
      'email': email,
      'phone': phone,
      'password': pass,
      'latitude': 0,
      'longitude': 0
    });
  }

  static Future<void> signIn(String email, String pass) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
  }

  static Future<List<Comment>> fillComments(String email) async {
    List<Comment> comments = [];
    CollectionReference info =
        FirebaseFirestore.instance.collection('commentaire');
    var userBase = await info.where("receiver", isEqualTo: email).get();
    if (userBase.docs.isNotEmpty) {
      for (var i = 0; i < userBase.docs.length; i++) {
        comments.add(Comment(
            name: userBase.docs[i]['senderName'],
            comment: userBase.docs[i]['text'],
            imageUrl: userBase.docs[i]['senderImage'],
            rate: userBase.docs[i]['rate']));
      }
    }
    return comments;
  }

  static Future<Map<String, String>> getSenderInformationsForProfile(
      String collectionS, String email) async {
    Map<String, String> res = new Map();
    CollectionReference info =
        FirebaseFirestore.instance.collection(collectionS);
    var userBase = await info.where("email", isEqualTo: email).get();
    if (userBase.docs.isNotEmpty) {
      res.addAll({"sender_name": userBase.docs[0]['name']});
    }
    await FirebaseStorage.instance
        .ref('profiles/${email}')
        .getDownloadURL()
        .then(
      (value) {
        res.addAll({"sender_image": value});
      },
    );
    return res;
  }

  static Future<void> getReceiverInformations(
      String collectionR, String email) async {
    Map<String, dynamic> res = new Map();
    CollectionReference info =
        FirebaseFirestore.instance.collection(collectionR);
    var userBase = await info.where("email", isEqualTo: email).get();
    if (userBase.docs.isNotEmpty) {
      res.addAll({"receiver_name": userBase.docs[0]['name']});
      if (collectionR == "prestataire") {
        res.addAll({"receiver_description": userBase.docs[0]['description']});
        res.addAll({"receiver_job": userBase.docs[0]['service']});
        double roundedNumber = double.parse(
            (userBase.docs[0]['rate'] / userBase.docs[0]['nbRates'])
                .toStringAsFixed(1));
        res.addAll({"receiver_rate": roundedNumber});
        res.addAll({"receiver_nbRates": userBase.docs[0]['nbRates']});
      }
      res.addAll({"receiver_tel": userBase.docs[0]['phone']});
    }
    await FirebaseStorage.instance
        .ref('profiles/${email}')
        .getDownloadURL()
        .then(
      (value) {
        res.addAll({"receiver_image": value});
      },
    );
  }

  static Future<void> addComment(
      String collectionR,
      String sender,
      String receiver,
      double nbStar,
      String comment,
      String nameS,
      var imageS) async {
    final info = await FirebaseFirestore.instance.collection(collectionR);
    final query = await info.where('email', isEqualTo: receiver);
    final snapshot = await query.get();
    int sur = 1;
    if (snapshot.docs[0]['rate'] == 0) {
      sur = 1;
    } else {
      sur = 2;
    }
    await snapshot.docs[0].reference.update({
      'nbRates': snapshot.docs[0]['nbRates'] + 1,
      'rate': snapshot.docs[0]['rate'] + nbStar,
    });
    CollectionReference colRef =
        FirebaseFirestore.instance.collection('commentaire');
    colRef.add({
      'receiver': receiver,
      'sender': sender,
      'text': comment,
      'time': FieldValue.serverTimestamp(),
      'rate': nbStar,
      'senderName': nameS,
      'senderImage': imageS
    });
  }

  static Future<void> addUserImage(
      bool google, String email, var profile, String profileName) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      if (!google) {
        await storage.ref('profiles/${email}').putFile(profile); //file name
      } else {
        http.Response response = await http.get(Uri.parse(profile));
        await storage
            .ref('profiles/${email}')
            .putData(response.bodyBytes); //file name
      }
      profileName = await storage.ref('profiles/${email}').getDownloadURL();
    } catch (e) {}
  }
}
