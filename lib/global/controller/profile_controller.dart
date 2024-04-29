import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  Future updateUserPersonalInfo() async {}

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
}
