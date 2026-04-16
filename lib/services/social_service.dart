import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<dynamic> signInWithFacebook() async {
  try {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      final userInfo = await FacebookAuth.instance.getUserData();
      return userInfo;
      //final AccessToken accessToken = loginResult.accessToken!;
      // final OAuthCredential credential = FacebookAuthProvider.credential(
      //   accessToken.tokenString,
      // );
      //return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      throw FirebaseAuthException(
        code: 'Facebook Login Failed',
        message: 'The Facebook login was not successful.',
      );
    }
  } on FirebaseAuthException {
    // Handle Firebase authentication exceptions
    rethrow; // rethrow the exception
  } catch (e) {
    // Handle other exceptions
    rethrow; // rethrow the exception
  }
}

Future<bool> signOutFromFacebook() async {
  try {
    await FacebookAuth.instance.logOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}
