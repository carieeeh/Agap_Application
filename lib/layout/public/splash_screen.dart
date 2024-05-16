import 'dart:async';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    initFunc();
  }

  Future<void> initFunc() async {
    await _auth.checkAuth();
    // await _auth.setLocalAuth();

    _settingsController.handleForegroundMessaging();

    Timer(const Duration(seconds: 2), () async {
      if (_auth.hasUser.isTrue) {
        await _auth
            .findUserInfo(_auth.currentUser!.uid)
            .then((Object? value) async {
          if (value != null) {
            _auth.signIn(value);
          }
        });
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/red_no_bg_logo.png',
                  width: Get.width * .85,
                ),
                SizedBox(height: Get.height * .05),
                LoadingAnimationWidget.prograssiveDots(
                  color: primaryRed,
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
