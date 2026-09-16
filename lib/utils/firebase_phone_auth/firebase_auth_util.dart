// ignore_for_file: prefer_function_declarations_over_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseAuthUtil {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> login({
    required String mobileNumber,
    required ValueChanged<String> onCodeSent,
    required ValueChanged<FirebaseAuthException> onVerificationFailed,
    // required VoidCallback onTimeout,
  }) async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {};

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      onVerificationFailed(authException);
    };

    final PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) {
      onCodeSent(verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {};

    return firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      timeout: const Duration(seconds: 20),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> verifyOTPCode({
    required String verificationId,
    required String verificationCode,
    required ValueChanged<User> onVerificationSuccess,
    required ValueChanged<FirebaseAuthException> onCodeVerificationFailed,
  }) async {
    final AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: verificationCode);
    await firebaseAuth.signInWithCredential(credential).then((value) {
      if (value.user != null) {
        onVerificationSuccess(value.user!);
      }
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        onCodeVerificationFailed(error);
      }
    });
  }
}