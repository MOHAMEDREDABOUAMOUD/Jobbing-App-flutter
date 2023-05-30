// ignore_for_file: unnecessary_new

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:signin_signup/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:signin_signup/models/worker.dart';

class DAO {
  static Future<String> getType(String email) async {
    try {
      final info = await FirebaseFirestore.instance.collection('client');
      final query = await info.where('email', isEqualTo: email);
      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        return "client";
      } else {
        return "prestataire";
      }
    } catch (e) {
      return "";
    }
  }

  static Future<Map<String, String>> getReceiverInfo(
      String collectionR, String email) async {
    Map<String, String> res = new Map();
    try {
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
    } catch (e) {
      return {};
    }
  }

  static Future<String> getSenderInfo(String collectionS, String email) async {
    try {
      var userBase = await FirebaseFirestore.instance
          .collection(collectionS)
          .where("email", isEqualTo: email)
          .get();
      if (userBase.docs.isNotEmpty) {
        return userBase.docs[0]['name'];
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  static Future<void> resetPass(String emaill) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emaill);
    } catch (e) {}
  }

  static Future<void> createAcc(String email, String pass) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } catch (e) {}
  }

  static Future<void> addUserIdentity(
      String email, var cardFront, var cardBack) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref('profiles/$email-front').putFile(cardFront); //file name
      await storage.ref('profiles/$email-back').putFile(cardBack); //file name
    } catch (e) {}
  }

  static Future<void> addUserinformations(
      String name,
      String email,
      String phone,
      String pass,
      String service,
      String description,
      double latitude,
      double longitude) async {
    try {
      await FirebaseFirestore.instance.collection("prestataire").add({
        'name': name,
        'email': email,
        'phone': phone,
        'password': pass,
        'latitude': latitude,
        'longitude': longitude,
        'service': service,
        'description': description,
        'rate': 0.0,
        'nbRates': 0
      });
    } catch (e) {}
  }

  static Future<void> addUserinformationsC(
      String name, String email, String phone, String pass) async {
    try {
      await FirebaseFirestore.instance.collection("client").add({
        'name': name,
        'email': email,
        'phone': phone,
        'password': pass,
        'latitude': 0,
        'longitude': 0
      });
    } catch (e) {}
  }

  static Future<bool> signIn(String email, String pass) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isEmailExist(String email) async {
    try {
      CollectionReference info =
          FirebaseFirestore.instance.collection('client');
      var userBase = await info.where("email", isEqualTo: email).get();
      if (userBase.docs.isEmpty) {
        info = FirebaseFirestore.instance.collection('prestataire');
        userBase = await info.where("email", isEqualTo: email).get();
        if (userBase.docs.isEmpty) {
          return false;
        } else
          return true;
      } else
        return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Comment>> fillComments(String email) async {
    List<Comment> comments = [];
    try {
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
    } catch (e) {
      return comments;
    }
  }

  static Future<Map<String, String>> getSenderInformationsForProfile(
      String collectionS, String email) async {
    Map<String, String> res = {};
    try {
      CollectionReference info =
          FirebaseFirestore.instance.collection(collectionS);
      var userBase = await info.where("email", isEqualTo: email).get();
      if (userBase.docs.isNotEmpty) {
        res.addAll({"sender_name": userBase.docs[0]['name']});
        res.addAll({'phone': userBase.docs[0]['phone']});
      }
      await FirebaseStorage.instance
          .ref('profiles/$email')
          .getDownloadURL()
          .then(
        (value) {
          res.addAll({"sender_image": value});
        },
      );
      return res;
    } catch (e) {
      return res;
    }
  }

  static Future<Map<String, dynamic>> getReceiverInformations(
      String collectionR, String email) async {
    Map<String, dynamic> res = new Map();
    try {
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
      return res;
    } catch (e) {
      return res;
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
    try {
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
    } catch (e) {}
  }

  static Future<void> addUserImage(
      bool google, String email, var profile, String profileName) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      if (!google) {
        await storage.ref('profiles/${email}').putFile(profile); //file name
      } else {
        http.Response response = await http.get(Uri.parse(profile));
        await storage
            .ref('profiles/${email}')
            .putData(response.bodyBytes); //file name
      }
      profileName = await storage.ref('profiles/${email}').getDownloadURL();
      print(
          "$profileName***************************************************************");
    } catch (e) {}
  }

  static Future<List<Worker>> getWorkers(String service) async {
    List<Worker> w = [];
    try {
      var userBase = await FirebaseFirestore.instance
          .collection("prestataire")
          .where("service", isEqualTo: service)
          .get();
      for (var i = 0; i < userBase.docs.length; i++) {
        String url = "";
        await FirebaseStorage.instance
            .ref('profiles/${userBase.docs[i]['email']}')
            .getDownloadURL()
            .then(
          (value) {
            url = value;
          },
        );
        w.add(new Worker(
            userBase.docs[i]['name'],
            url,
            double.parse(
                (userBase.docs[i]['rate'] / userBase.docs[i]['nbRates'])
                    .toStringAsFixed(1)),
            userBase.docs[i]['description'],
            userBase.docs[i]['email']));
      }
      return w;
    } catch (e) {
      return w;
    }
  }

  static Future<List<Map<String, String>>> getTalkTo(String email) async {
    List<Map<String, String>> res = [];
    try {
      List<String> check = [];
      print(
          "enter ************************************************************");
      var userBase = await FirebaseFirestore.instance
          .collection("messages")
          .where("sender", isEqualTo: email)
          .get();
      var userBase2 = await FirebaseFirestore.instance
          .collection("messages")
          .where("receiver", isEqualTo: email)
          .get();
      var userBase3 = userBase.docs + userBase2.docs;
      for (var i = 0; i < userBase3.length; i++) {
        if (userBase3[i]['sender'] == email) {
          String url = "";
          print(
              'profiles/${userBase3[i]['receiver']}***********************************');
          await FirebaseStorage.instance
              .ref('profiles/${userBase3[i]['receiver']}')
              .getDownloadURL()
              .then(
            (value) {
              url = value;
            },
          );
          if (!check.contains(userBase3[i]['receiver'])) {
            check.add(userBase3[i]['receiver']);
            res.add({userBase3[i]['receiver']: url});
          }
          print(
              "receiver ************************************************************");
        } else {
          String url = "";
          print(
              'profiles/${userBase3[i]['sender']}***********************************');
          await FirebaseStorage.instance
              .ref('profiles/${userBase3[i]['sender']}')
              .getDownloadURL()
              .then(
            (value) {
              url = value;
            },
          );
          if (!check.contains(userBase3[i]['sender'])) {
            res.add({userBase3[i]['sender']: url});
            check.add(userBase3[i]['sender']);
          }
          print(
              "sender ************************************************************");
        }
      }
      return res;
    } catch (e) {
      return res;
    }
  }

  static List<String> getTalkToList(String email) {
    List<String> result = [];
    try {
      List<Map<String, String>> res =
          DAO.getTalkTo(email) as List<Map<String, String>>;
      for (var i = 0; i < res.length; i++) {
        result.add(res[i].keys as String);
      }
      return result;
    } catch (e) {
      return result;
    }
  }

  static Future<String> getUserName(String email) async {
    try {
      var userBase = await FirebaseFirestore.instance
          .collection("client")
          .where("email", isEqualTo: email)
          .get();
      if (userBase.docs.length == 1) {
        return userBase.docs[0]['name'];
      } else {
        userBase = await FirebaseFirestore.instance
            .collection("prestataire")
            .where("email", isEqualTo: email)
            .get();
        if (userBase.docs.length == 1) return userBase.docs[0]['name'];
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  static Future<void> addDemand(String client, String prestataire, String date,
      String time, String description) async {
    try {
      await FirebaseFirestore.instance.collection("demande").add({
        'client': client,
        'prestataire': prestataire,
        'date': date,
        'time': time,
        'description': description
      });
    } catch (e) {}
  }
}
