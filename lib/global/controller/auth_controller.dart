import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/model/user_model.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

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
    isLoading.value = true;
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
      } finally {
        isLoading.value = false;
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
    isRescuer.value = false;
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
            signUp(
              UserModel(
                  uid: currentUser!.uid,
                  firstName: 'Guest',
                  lastName: DateTime.now().second.toString(),
                  role: 'resident',
                  status: 'accepted',
                  contactNumber: currentUser!.phoneNumber,
                  profile:
                      "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/profile%2Fperson.png?alt=media&token=947f5244-0157-43ab-8c3e-349ae9699415"),
            );
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
    if (userModel?.status == "blocked") {
      Get.dialog(
        barrierDismissible: false,
        const GetDialog(
          type: 'success',
          title: 'Your account is blocked',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Please contact our team in case of a problem.',
        ),
      );
      Get.offAllNamed('/login');
    } else {
      if (userModel?.role == 'rescuer') {
        if (userModel?.status == "accepted") {
          Get.dialog(
            barrierDismissible: false,
            const GetDialog(
              type: 'success',
              title: 'Registration in progress',
              hasMessage: true,
              buttonNumber: 0,
              hasCustomWidget: false,
              withCloseButton: true,
              message: 'Your account is still in review...',
            ),
          );
          Get.offAllNamed('/login');
        } else {
          isRescuer.value = true;
          Get.offAllNamed('/interactive_map');
        }
      } else {
        isRescuer.value = false;
        Get.offAllNamed("/home");
      }
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

      isRescuer.isFalse ? signIn(value) : Get.offAllNamed('/login');

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
    required String stationCode,
    required String firstName,
    String? middleName,
    required String lastName,
    required String contactNumber,
    required String email,
  }) {
    if (stationCode.isEmpty) return 'Station Code';
    if (firstName.isEmpty) return 'First Name';
    if (lastName.isEmpty) return 'Last Name';
    if (contactNumber.isEmpty) return 'Contact Number';
    if (email.isEmpty) return 'Email';
    return null; // Return null if all required fields are non-empty
  }

  Future<void> rescuerRegister({
    required String stationCode,
    required String firstName,
    String? middleName,
    required String lastName,
    required String contactNumber,
    String? emeContactNumber,
    required String email,
  }) async {
    String? emptyField = findEmptyField(
      stationCode: stationCode,
      firstName: firstName,
      lastName: lastName,
      contactNumber: contactNumber,
      email: email,
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
      profile:
          "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/profile%2Fperson.png?alt=media&token=947f5244-0157-43ab-8c3e-349ae9699415",
      status: 'pending',
      email: email,
      department: stationCode,
    );

    phoneNumber.value = contactNumber;
    requestOTP();
    Get.toNamed('/otp-page');
  }

  Future<void> logOut() async {
    try {
      isLoading.value = true;
      isRescuer.value = false;
      isAuth.value = false;
      isLoading.value = false;
      hasUser.value = false;
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');
    } catch (error) {
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
