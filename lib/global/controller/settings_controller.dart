import 'dart:async';
import 'dart:developer';

import 'package:agap_mobile_v01/layout/widgets/dialog/rescuer_dialog.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxInt countdown = 120.obs; // 5 minutes in seconds
  RxBool isTimerFinish = false.obs;
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
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      if (message.data.containsKey("for") && message.data["for"] == "rescuer") {
        Get.dialog(
          barrierDismissible: false,
          const RescuerDialog(
            imageUrls: [
              "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/reports%2F03449610-b415-4074-9113-25cb412370a19036972169380946478.jpg?alt=media&token=fb3db17e-70dc-4db1-b459-85a52847dd8d",
              "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/reports%2F19b9ec7c-4cb8-49f9-b45e-6c8c3f5921e88009505196286664570.jpg?alt=media&token=1e5b8a7b-c8f5-4f48-aba8-7854b640f5ae",
              "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/reports%2F7689ca56-98a2-4299-b8b8-80be03d3bacf9006339925831303307.jpg?alt=media&token=41534714-daa4-4f97-be77-6442ac5e5a27",
            ],
            type: "Fire",
            location: "ASD st. brgy. 123, Manila city",
            totalUnits: "4",
            description: "Need help ASAP!",
          ),
        );
      } else {}
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
