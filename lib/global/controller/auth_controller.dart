import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/model/user_model.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs,
      isRescuer = false.obs,
      isAuth = false.obs,
      hasUser = false.obs,
      isSupported = false.obs,
      isBioEnabled = false.obs;
  RxString phoneNumber = ''.obs;
  Rx<TextEditingController> pinCode = TextEditingController().obs;
  int? _forceResendingToken;
  PhoneAuthCredential? _userCredential;
  String _verificationId = '';
  UserModel? userModel;
  User? currentUser;

  Future<void> setLocalAuth() async {
    final LocalAuthentication auth = LocalAuthentication();

    auth.isDeviceSupported().then(
        (bool isDeviceSupported) => isSupported.value = isDeviceSupported);
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    isBioEnabled.value = availableBiometrics.isNotEmpty && isSupported.isTrue;
  }

  Future<void> localAuthenticate() async {
    final LocalAuthentication auth = LocalAuthentication();

    if (isBioEnabled.isTrue) {
      try {
        bool localAuthenticated = await auth.authenticate(
            localizedReason: "Authenticate to Login in the system.",
            options: const AuthenticationOptions(
              stickyAuth: true,
            ));
        if (localAuthenticated) {
          isAuth.value = localAuthenticated;
          await findUserInfo(currentUser!.uid).then((Object? value) async {
            if (value != null) {
              signIn(value);
            }
          });
        }
      } on PlatformException catch (error) {
        Get.dialog(
          barrierDismissible: false,
          GetDialog(
            type: 'error',
            title: 'Login failed.',
            hasMessage: true,
            buttonNumber: 0,
            hasCustomWidget: false,
            withCloseButton: true,
            message: 'Please use the other option. \nError: $error',
          ),
        );
      }
    }
  }

  Future<void> checkAuth() async {
    if (FirebaseAuth.instance.currentUser != null) {
      currentUser = FirebaseAuth.instance.currentUser;
      hasUser.value = true;
    }
  }

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

      await findUserInfo(currentUser!.uid).then((Object? value) async {
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
    await updateFCMToken(currentUser!.uid);

    isAuth.value = true;
    isLoading.value = false;

    if (userModel?.role == 'rescuer') {
      isRescuer.value = true;
      Get.offAllNamed('/interactive_map');
    } else {
      isRescuer.value = false;
      Get.offAllNamed("/home");
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

      isRescuer.isFalse ? Get.offAllNamed("/home") : Get.offAllNamed('/login');
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

  String? findEmptyField({
    required String firstName,
    String? middleName,
    required String lastName,
    required String contactNumber,
    required String emeContactNumber,
    required String email,
    required String department,
  }) {
    if (firstName.isEmpty) return 'First Name';
    if (lastName.isEmpty) return 'Last Name';
    if (contactNumber.isEmpty) return 'Contact Number';
    if (emeContactNumber.isEmpty) return 'Emergency Contact Number';
    if (email.isEmpty) return 'Email';
    if (department.isEmpty) return 'Department';
    return null; // Return null if all required fields are non-empty
  }

  Future<void> rescuerRegister({
    required String firstName,
    String? middleName,
    required String lastName,
    required String contactNumber,
    required String emeContactNumber,
    required String email,
    required String department,
  }) async {
    String? emptyField = findEmptyField(
      firstName: firstName,
      lastName: lastName,
      contactNumber: contactNumber,
      emeContactNumber: emeContactNumber,
      email: email,
      department: department,
    );

    if (emptyField != null) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Registration Failed',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Empty field: $emptyField',
        ),
      );
      return;
    }

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
      department: department,
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
    hasUser.value = false;
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

  Future<void> updateFCMToken(String uid) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

    final QuerySnapshot querySnapShot = await firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
    querySnapShot.docs.first.reference.update({"fcm_token": fcmToken});
  }
}
