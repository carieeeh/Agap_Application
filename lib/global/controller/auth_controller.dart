import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/model/user_model.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  UserModel? userModel;
  User? currentUser;

  // request otp for phone number ex. 9487123123
  Future<void> requestOTP() async {
    isLoading.value = true;
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
            title: 'Phone number verification failed',
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
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
    });
  }

  // verify otp and login the user
  Future<void> verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: pinCode.value.text);
    _userCredential = credential;
    isLoading.value = true;
    await FirebaseAuth.instance
        .signInWithCredential(_userCredential!)
        .then((UserCredential userCredential) async {
      currentUser = userCredential.user;

      await findUserInfo(currentUser!.uid).then((Object? value) {
        if (value != null) {
          signIn(value);
        } else {
          if (isRescuer.isTrue && userModel != null) {
            userModel!.uid = currentUser!.uid;
            signUp(userModel!);
          } else {
            signUp(UserModel(
              uid: currentUser!.uid,
              firstName: 'Guest',
              lastName: DateTime.now().second.toString(),
              role: 'resident',
              status: 'accepted',
              contactNumber: currentUser!.phoneNumber,
            ));
          }
        }
      });
    }).catchError((error) {
      isLoading.value = false;

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

  Future signIn(value) async {
    userModel = UserModel.fromJson(value);

    isAuth.value = true;
    isLoading.value = false;

    if (userModel?.role == 'rescuer') {
      isRescuer.value = true;
      Get.offAllNamed('/interactive_map');
    } else {
      isRescuer.value = false;
      Get.offAllNamed('/');
    }
  }

  Future signUp(UserModel model) async {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

    await firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('users')
        .add(model.toJson())
        .then((value) async {
      isLoading.value = false;

      await Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'success',
          title: 'Registration success',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: isRescuer.isFalse
              ? 'Thank you for registering in our app.'
              : 'An email will be sent when your account is ready to use.',
        ),
      );

      isRescuer.isFalse ? Get.offAllNamed('/') : Get.offAllNamed('/login');
    }).catchError((error) {
      isLoading.value = false;

      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'success',
          title: 'Registration failed',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Something went wrong. \n Error: $error',
        ),
      );
    });
  }

  Future<void> getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Get.dialog(
        barrierDismissible: false,
        const GetDialog(
          type: 'error',
          title: 'Login Failed',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message:
              'Error: No user found! \nPlease log out then log in your account',
        ),
      );
    }
  }

  Future<void> rescuerRegister({
    required String firstName,
    String? middleName,
    required String lastName,
    required String contactNumber,
    required String emeContactNumber,
    required String email,
  }) async {
    isRescuer.value = true;

    userModel = UserModel(
      role: 'rescuer',
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      contactNumber: contactNumber,
      emeContactNumber: emeContactNumber,
      status: 'pending',
      email: email,
    );

    phoneNumber.value = contactNumber;
    requestOTP();
    Get.toNamed('/otp-page');
  }

  Future<void> logOut() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;
    localStorage.clear();
    isRescuer.value = false;
    await FirebaseAuth.instance.signOut();
    isAuth.value = false;
    isLoading.value = false;
    Get.offAllNamed('/login');
  }

  Future<Object?> findUserInfo(String uid) async {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

    QuerySnapshot querySnapShot = await firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    return querySnapShot.docs.isNotEmpty ? querySnapShot.docs[0].data() : null;
  }
}
