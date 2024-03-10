import 'dart:convert';
import 'dart:developer';

import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs, isRescuer = false.obs, isAuth = false.obs;
  RxString phoneNumber = ''.obs;
  Rx<TextEditingController> pinCode = TextEditingController().obs;
  int? _forceResendingToken;
  PhoneAuthCredential? _userCredential;
  String _verificationId = '';

  // request otp for phone number ex. 9487123123
  Future<void> requestOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+63${phoneNumber.value}",
      timeout: const Duration(minutes: 2),
      verificationCompleted: (phoneAuthCredential) async {
        pinCode.value.setText(phoneAuthCredential.smsCode!);
        _userCredential = phoneAuthCredential;
      },
      verificationFailed: (error) {
        Get.dialog(
          barrierDismissible: false,
          GetDialog(
            type: 'error',
            title: 'Login Failed',
            hasMessage: true,
            buttonNumber: 0,
            hasCustomWidget: false,
            withCloseButton: true,
            message: 'Error code: ${error.code}',
          ),
        );
      },
      codeSent: (verificationId, forceResendingToken) async {
        _forceResendingToken = forceResendingToken;
        _verificationId = verificationId;
      },
      forceResendingToken: _forceResendingToken,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  // verify otp and login the user
  Future<void> verifyOTP() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: pinCode.value.text);
    _userCredential = credential;

    await FirebaseAuth.instance
        .signInWithCredential(_userCredential!)
        .then((value) {
      log(value.toString());
      log(value.user.toString());

      User? user = FirebaseAuth.instance.currentUser;
      log(user.toString());
      localStorage.setString('user', jsonEncode(value.user));
      isAuth.value = true;
      Get.offAllNamed('/');
    }).catchError((error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Login Failed',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error code: $error',
        ),
      );
    });
  }

  Future<void> logOut() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    localStorage.clear();
    await FirebaseAuth.instance.signOut();
    isAuth.value = false;
    Get.offAllNamed('/login');
  }
}
