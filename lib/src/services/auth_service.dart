import 'package:firebase_auth/firebase_auth.dart';
// import 'package:lanterner/models/user.dart' as u;
// import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io' show Platform;


class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  // sign in with phone number
  Future<String?> signInWithPhone({required String phone, String? smsCode}) async {
    try{
      await _firebaseAuth.verifyPhoneNumber(
  phoneNumber:phone,
  verificationCompleted: (PhoneAuthCredential credential) async {

    if (Platform.isAndroid) {
// / ANDROID ONLY!
    // Sign the user in (or link) with the auto-generated credential
    await _firebaseAuth.signInWithCredential(credential);
    } 
    // TODO: confirm the credential on iOS
  },
  verificationFailed: (FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
    // Handle other errors
  },

  codeSent: (String verificationId, int? resendToken) async {
    // Update the UI - wait for the user to enter the SMS code
    String smsCode = 'xxxx';

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await _firebaseAuth.signInWithCredential(credential);
  },
  timeout: const Duration(seconds: 60),
  codeAutoRetrievalTimeout: (String verificationId) {
    // Auto-resolution timed out...
  },
);
    } on FirebaseAuthException catch (e) {
      return e.message; // return the error message can be used to give feedback to the user
    }
  }     


  // isAlreadyRegistered(String email) async {
  //   try {
  //     List<String> methods =
  //         await _firebaseAuth.fetchSignInMethodsForEmail(email);
  //     if (methods.isNotEmpty) {
  //       return false;
  //     }
  //   } catch (e) {
  //     return e.message;
  //   }
  // }

  // Future<String> resetPassword(String email) async {
  //   try {
  //     await _firebaseAuth.sendPasswordResetEmail(email: email);
  //     return 'an email has been sent to';
  //   } catch (e) {
  //     return e.message;
  //   }
  // }

  // sign out.
  Future<void> signout() async {
    await _firebaseAuth.signOut();
  }
}