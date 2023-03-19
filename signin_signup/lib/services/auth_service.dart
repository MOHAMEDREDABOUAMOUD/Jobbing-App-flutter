// ignore_for_file: non_constant_identifier_names, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  signInWithGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //create a new credential for user
    final Credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    //finally, lets  sign in
    return await FirebaseAuth.instance.signInWithCredential(Credential);
  }

  // signInWithFacebook() async {
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //   final AccessToken = loginResult.accessToken;
  //   final OAuthCredential facebookAuthCredential;
  //   if (AccessToken != null) {
  //     facebookAuthCredential =
  //         FacebookAuthProvider.credential(AccessToken.token);
  //     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   } else {
  //     print(
  //         "error************************************************************************");
  //     return null;
  //   }
  // }
}
