import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();

  @override
  void initState() {
    _settings.startCountdown(
      () {
        print("Finish");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 0,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: Get.height * .1),
                  Image.asset(
                    'assets/images/red_no_bg_logo.png',
                    width: Get.width * .50,
                  ),
                  SizedBox(height: Get.height * .1),
                  const Text(
                    "Verification",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text("Enter the code sent to the number:"),
                  const SizedBox(height: 10),
                  Text("+63${_auth.phoneNumber.value}"),
                  Center(
                    child: OTPInput(
                      pinController: _auth.pinCode.value,
                      label: '',
                      validation: (p0) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => RoundedCustomButton(
                      onPressed: () {
                        _settings.stopCountdown();
                        _auth.verifyOTP();
                      },
                      label: 'Verify',
                      isLoading: _auth.isLoading.isTrue,
                      loaderColor: colorSuccess,
                      bgColor: _auth.isLoading.isTrue ? gray : colorSuccess,
                      size: Size(Get.width * .8, 40),
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextButton(
                    onPressed: () {
                      if (_settings.isTimerFinish.isTrue) {
                        _auth.requestOTP();
                        _settings.countdown.value = 300;
                      }
                    },
                    child: Obx(
                      () => Text(
                        _settings.isTimerFinish.isTrue
                            ? 'Resend code'
                            : 'Resend code in: ${_formatDuration(Duration(seconds: _settings.countdown.value))}',
                        style: const TextStyle(color: darkGray),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
