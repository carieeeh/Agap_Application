import 'dart:convert';

import 'package:agap_mobile_v01/layout/widgets/dialog/rescuer_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    final emergency = jsonDecode(receivedNotification.body ?? "");

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
  }
}
