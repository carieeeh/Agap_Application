import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' show atan2, cos, pow, sin, sqrt;

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/private/resident/reports/report_feedback.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/rescuer_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxInt countdown = 120.obs; // 5 minutes in seconds
  RxBool isTimerFinish = false.obs, hasReport = false.obs;
  RxString rescuerUid = "".obs, emergencyDocId = "".obs;
  final AuthController _auth = Get.find<AuthController>();

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

      if (message.data.containsKey("purpose") &&
          message.data["purpose"] == "rescuer" &&
          _auth.isRescuer.isTrue) {
        final emergency = jsonDecode(message.data["emergency"]);

        List<String> fileUrls = emergency["file_urls"].cast<String>();
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: "rescuer_channel",
            title: message.data["title"],
            body: message.data["emergency"],
          ),
        );
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
      } else if (message.data.containsKey("purpose") &&
          _auth.isRescuer.isFalse) {
        Get.snackbar(
          message.data["title"],
          message.data["message"],
          duration: const Duration(seconds: 5),
          backgroundColor: colorSuccess,
        );
        if (message.data["purpose"] == "accepted") {
          rescuerUid.value = message.data["rescuer_uid"];
          hasReport.value = true;
          Get.toNamed('/rescuer_map_view');
        } else if (message.data["purpose"] == "finish") {
          hasReport.value = false;
          rescuerUid.value = message.data["rescuer_uid"];
          emergencyDocId.value = message.data["emergency_id"];
          Get.to(
            ReportFeedback(
              emergencyDocId: message.data["emergency_id"],
              role: "resident",
              userUid: message.data["rescuer_uid"],
            ),
          );
        }
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

  // Assuming you have latitude and longitude for start and finish points
  double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const int earthRadius = 6371; // Radius of the earth in km
    final double latDistance = (endLat - startLat) * (3.141592653589793 / 180);
    final double lonDistance = (endLng - startLng) * (3.141592653589793 / 180);
    final double a = pow(sin(latDistance / 2), 2) +
        pow(sin(lonDistance / 2), 2) *
            cos(startLat * (3.141592653589793 / 180)) *
            cos(endLat * (3.141592653589793 / 180));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in km
  }

// Assuming you have a speed in km/h
  DateTime calculateETA(double distanceInKm, double speed) {
    final double hours = distanceInKm / speed;
    final int minutes = (hours * 60).floor();
    return DateTime.now().add(Duration(minutes: minutes));
  }
}
