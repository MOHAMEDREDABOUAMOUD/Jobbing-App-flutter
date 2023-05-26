// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:signin_signup/pages/home_page.dart';
import 'package:signin_signup/pages/messagerie.dart';
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

  static Future<bool> SignUserUp(
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
    try {
      print(
          '*********************************************************************************************');
      Position position = await _getCurrentLocation(contextt);
      print(
          '${position.latitude}*********************************************************************************************');
      if (pass == repass) {
        //show loading circle

        // showDialog(
        //     context: contextt,
        //     builder: (context) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     });

        //signup
        if (google == false) {
          try {
            DAO.createAcc(email, pass);
          } catch (e) {}
        }
        //add user infos to cloud
        await DAO.addUserinformations(name, email, phone, pass, service,
            description, position.latitude, position.longitude); //
        await DAO.addUserIdentity(email, cardFront, cardBack);
        print(
            "signuserUp*****************************************************************");
        //Navigator.pop(contextt);
        //Navigator.pop(contextt);
        return true;
      } else {
        showErrorMessag(contextt);
        return false;
      }
    } on Exception catch (e) {
      return false;
    }
  }

  static Future<bool> checkIdentity(img.Image image, double threshold) async {
    // Convert the image to grayscale
    img.Image grayscaleImage = img.grayscale(image);

    // Define the Laplacian filter
    List<num> laplacianFilter = [0, 1, 0, 1, -4, 1, 0, 1, 0];

    // Apply the Laplacian filter to the grayscale image
    img.Image filteredImage =
        img.convolution(grayscaleImage, filter: laplacianFilter);

    // Compute the sharpness of the filtered image
    double sum = 0.0;
    for (int y = 0; y < filteredImage.height; y++) {
      for (int x = 0; x < filteredImage.width; x++) {
        var pixel = filteredImage.getPixel(x, y);
        int gray = img.getLuminance(pixel).round();
        sum += gray * gray;
      }
    }
    double sharpness = sum / (filteredImage.width * filteredImage.height);

    // Determine if the image is clear or not based on the sharpness
    if (sharpness >= threshold)
      print("image is good");
    else
      print("image is bad");
    return sharpness >= threshold;
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

  static Future<bool> signUserIn(
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
      await DAO.signIn(email, pass).then((value) {
        if (value == true) {
          //await getUserInformations();
          Navigator.pop(contextt);
          Navigator.push(
            contextt,
            MaterialPageRoute(
              builder: (context) => Main(email: email),
            ),
          );
          return true;
        } else {
          Navigator.pop(contextt);
          showDialog(
              context: contextt,
              builder: (context) {
                return const AlertDialog(
                  title: Text("account not fount"),
                );
              });
          return false;
        }
      });
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(contextt);
      if (e.code == 'user-not-found') {
        wrongEmailMessage(contextt);
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage(contextt);
      }
      return false;
    } on Exception catch (e) {
      Navigator.pop(contextt);
      return false;
    }
  }

  static Future<bool> addComment(
      String collectionR,
      String sender,
      String receiver,
      double nbStar,
      String comment,
      String nameS,
      var imageS) async {
    try {
      await DAO.addComment(
          collectionR, sender, receiver, nbStar, comment, nameS, imageS);
      return true;
    } on Exception catch (e) {
      return false;
    }
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

  static Future<bool> SignUserUpC(
      bool google,
      var contextt,
      String email,
      String pass,
      String repass,
      String name,
      String phone,
      var profile,
      String profileName) async {
    try {
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
        await DAO.isEmailExist(email).then((value) async {
          if (value == false) {
            //add user infos to cloud
            await addUserinformations(email, pass, name, phone)
                .then((value) async {
              await addUserImage(google, email, profile, profileName)
                  .then((value) {});
            });
          }
        });
        Navigator.pop(contextt);
        //Navigator.pop(contextt);
        return true;
      } else {
        showErrorMessagPass(contextt);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<double> getDemandesStatsOfYear(String email, int month) async {
    return await DAO.getDemandesStatsOfYear(email, month);
  }

  static Future<double> getServicesStats(String service) async {
    return await DAO.getServicesStats(service);
  }

  static Future<int> getNombreC() async {
    return await DAO.getNombreC();
  }

  static Future<int> getNombreP() async {
    return await DAO.getNombreP();
  }

  static Future<int> getNombreD() async {
    return await DAO.getNombreD();
  }

  static Future<bool> addUserinformations(
      String email, String pass, String name, String phone) async {
    try {
      await DAO.addUserinformationsC(name, email, phone, pass);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addUserImage(
      bool google, String email, var profile, String profileName) async {
    try {
      await DAO.addUserImage(google, email, profile, profileName);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Position> _getCurrentLocation(var context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Location services disabled"),
              content: Text(
                  "Please give us location permission to use this feature."),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Open settings"),
                  onPressed: () async {
                    Navigator.pop(context);
                    await Geolocator
                        .openAppSettings(); //openLocationSettings();
                  },
                ),
              ],
            );
          },
        );
      } else if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {}
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Location services disabled"),
                content: Text(
                    "Please enable location services to use this feature."),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("Open settings"),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Geolocator.openLocationSettings();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }

    print("before ***********************************************************");
    permission = await Geolocator.checkPermission();
    print(
        "entergetcurrentlocation *****************************************************************************");
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }
    print(
        "return location *****************************************************************************");

    return await Geolocator.getCurrentPosition();
  }
}
