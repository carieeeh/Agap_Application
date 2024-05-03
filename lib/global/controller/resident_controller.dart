import 'dart:convert';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/model/user_model.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  RxString selectedBadgeUrl = "".obs;
  RxBool isLoading = false.obs, hasReport = false.obs;
  RxList userCurrentBadges = [].obs;
  RxInt userTotalPoints = 0.obs;
  Rx<UserModel> resident = UserModel().obs;

  Future updateResidentAgapPoints(int points) async {
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
        if (userTotalPoints.value >= points) {
          userCurrentBadges.add(badgeUrl);
          userTotalPoints.value -= points;
          querySnapShot.docs.first.reference.update({
            "agap_points": userTotalPoints.value,
            "badges": userCurrentBadges,
          });
          Get.back();
          Get.snackbar(
            "Success buying badge!",
            "You now have a new badge!",
            duration: const Duration(seconds: 5),
            backgroundColor: colorSuccess,
          );
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
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();

    String? badgeUrl = localStorage.getString("userBadge");

    final uid = _auth.currentUser!.uid;
    final collection = getCollectionReference();

    final QuerySnapshot querySnapShot =
        await collection.where('uid', isEqualTo: uid).get();

    if (querySnapShot.docs.isNotEmpty) {
      final encoded = jsonEncode(querySnapShot.docs.first.data());
      final agapData = jsonDecode(encoded);
      userTotalPoints.value = agapData["agap_points"];
      userCurrentBadges.value = agapData["badges"];
    } else {
      await collection.add({
        "uid": uid,
        "agap_points": 0,
        "badges": [""],
      });
    }

    if (badgeUrl != null) {
      selectedBadgeUrl.value = badgeUrl;
    } else if (userCurrentBadges[0] != "") {
      selectedBadgeUrl.value = userCurrentBadges[0];
      localStorage.setString("userBadge", userCurrentBadges[0]);
    } else {
      selectedBadgeUrl.value = "";
    }
  }

  void selectBadge(String badgeUrl) {
    selectedBadgeUrl.value = badgeUrl;
    Get.back();
    Get.snackbar(
      "Success",
      "You selected a badge to display!",
      duration: const Duration(seconds: 5),
      backgroundColor: colorSuccess,
    );
  }

  CollectionReference<Map<String, dynamic>> getCollectionReference() {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

    return firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('user_badges');
  }
}
