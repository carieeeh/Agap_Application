import 'dart:async';
import 'dart:developer';

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

    print(settings);
  }

  void handleForegroundMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
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
