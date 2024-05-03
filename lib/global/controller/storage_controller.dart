import 'dart:io';

import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StorageController extends GetxController {
  RxBool isLoading = false.obs;

  Future<String> uploadFile(XFile file, String folder) async {
    isLoading.value = true;
    try {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('$folder/${file.name}');
      UploadTask uploadTask = storageRef.putFile(File(file.path));

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String fileUrl = await taskSnapshot.ref.getDownloadURL();

      return fileUrl;
    } on FirebaseException catch (error) {
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
      return "";
    } finally {
      isLoading.value = false;
    }
  }
}
