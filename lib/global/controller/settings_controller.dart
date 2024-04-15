import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/private/resident/reports/report_feedback.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/rescuer_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxInt countdown = 120.obs; // 5 minutes in seconds
  RxBool isTimerFinish = false.obs, hasReport = false.obs;
  RxString rescuerUid = "".obs, emergencyDocId = "".obs;

  Timer? _timer;

  void startCountdown(Function() onFinish) {
    countdown.value = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _timer?.cancel();
        isTimerFinish.value = true;
        onFinish();
        // Do something when countdown finishes
      }
    });
  }

  void stopCountdown() {
    _timer?.cancel();
  }

  Future<void> initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log(settings.toString());
  }

  void handleForegroundMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Message data: ${message.data.toString()}');

      Get.snackbar(
        message.data["title"],
        message.data["message"],
        duration: const Duration(seconds: 5),
        backgroundColor: colorSuccess,
      );

      if (message.data.containsKey("purpose") &&
          message.data["purpose"] == "rescuer") {
        final emergency = jsonDecode(message.data["emergency"]);

        List<String> fileUrls = emergency["file_urls"].cast<String>();

        Get.dialog(
          barrierDismissible: false,
          RescuerDialog(
            imageUrls: fileUrls,
            type: emergency["type"],
            location: emergency["address"],
            totalUnits: emergency["total_units"].toString(),
            description: emergency["description"],
            residentUid: emergency["resident_uid"],
            geoPoint: GeoPoint(
              emergency["geopoint"]["latitude"],
              emergency["geopoint"]["longitude"],
            ),
            emergencyId: emergency["docId"],
          ),
        );
      } else if (message.data.containsKey("purpose")) {
        if (message.data["purpose"] == "accepted") {
          rescuerUid.value = message.data["rescuer_uid"];
          hasReport.value = true;
          Get.toNamed('/rescuer_map_view');
        }
      } else if (message.data.containsKey("finish")) {
        hasReport.value = false;
        rescuerUid.value = message.data["rescuer_uid"];
        emergencyDocId.value = message.data["emergency_id"];
        Get.to(ReportFeedback(
          emergencyDocId: message.data["emergency_id"],
          role: "resident",
          userUid: message.data["rescuer_uid"],
        ));
      }
    });
  }

  Future<void> callFunction(
    String token,
    Map<String, dynamic> data,
  ) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable("sendNotification");

    try {
      final result = await callable.call({
        "token": token,
        "data": data,
      });

      return result.data; // Return the response data if needed
    } on FirebaseFunctionsException catch (error) {
      print(error.message);
    }
  }
}
