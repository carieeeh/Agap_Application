import 'dart:convert';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ResidentController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  RxBool isLoading = false.obs;
  RxInt userTotalPoints = 0.obs;

  Future updateResidentAgapPoints(String points) async {
    final uid = _auth.currentUser!.uid;

    final collection = getCollectionReference();

    final QuerySnapshot querySnapShot =
        await collection.where('uid', isEqualTo: uid).get();

    if (querySnapShot.docs.isEmpty) {
      await collection.add({
        "uid": uid,
        "agap_points": points,
        "badges": [""],
      });
    } else {
      querySnapShot.docs.first.reference.update({"agap_points": points});
    }
  }

  Future buyBadges(
    String badgeUrl,
    int points,
  ) async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final collection = getCollectionReference();

      final QuerySnapshot querySnapShot =
          await collection.where('uid', isEqualTo: uid).get();

      if (querySnapShot.docs.isEmpty) {
        Get.dialog(
          barrierDismissible: false,
          const GetDialog(
            type: 'error',
            title: 'Something went wrong',
            hasMessage: true,
            buttonNumber: 0,
            hasCustomWidget: false,
            withCloseButton: true,
            message: 'You do not have enough AGAP points.',
          ),
        );
      } else {
        final encoded = jsonEncode(querySnapShot.docs.first.data());
        final agapData = jsonDecode(encoded);
        List badges = agapData["badges"];

        if (points >= userTotalPoints.value) {
          badges.add(badgeUrl);
        } else {
          Get.dialog(
            barrierDismissible: false,
            const GetDialog(
              type: 'error',
              title: 'Something went wrong',
              hasMessage: true,
              buttonNumber: 0,
              hasCustomWidget: false,
              withCloseButton: true,
              message: 'You do not have enough AGAP points.',
            ),
          );
        }

        querySnapShot.docs.first.reference.update({"badges": badges});
      }
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: "error",
          title: "Something went wrong",
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: "Error: ${error.toString()}",
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserCurrentPoints() async {
    final uid = _auth.currentUser!.uid;
    final collection = getCollectionReference();

    final QuerySnapshot querySnapShot =
        await collection.where('uid', isEqualTo: uid).get();

    if (querySnapShot.docs.isNotEmpty) {
      final encoded = jsonEncode(querySnapShot.docs.first.data());
      final agapData = jsonDecode(encoded);
      userTotalPoints.value = int.parse(agapData["agap_points"]);
    } else {
      await collection.add({
        "uid": uid,
        "agap_points": 0,
        "badges": [""],
      });
    }
  }

  CollectionReference<Map<String, dynamic>> getCollectionReference() {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

    return firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('user_badges');
  }
}
