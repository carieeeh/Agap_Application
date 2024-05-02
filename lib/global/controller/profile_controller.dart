import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  Future updateUserPhoneNumber(String currentPhoneNumber) async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: currentPhoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential);
        // either this occurs or the user needs to manually enter the SMS code
      },
      verificationFailed: (error) {},
      codeSent: (verificationId, [forceResendingToken]) async {
        String smsCode = "";
        // get the SMS code from the user somehow (probably using a text field)
        final PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    isLoading.value = true;
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
    try {
      final QuerySnapshot querySnapShot = await firestoreDb
          .collection("agap_collection")
          .doc(fireStoreDoc)
          .collection('users')
          .where('uid', isEqualTo: currentUser!.uid)
          .get();
      querySnapShot.docs.first.reference.update(data);
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Registration Failed',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Empty field: $error',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
