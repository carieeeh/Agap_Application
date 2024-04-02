import 'dart:async';

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
}
