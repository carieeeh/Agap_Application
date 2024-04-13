import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController _phoneNumber = TextEditingController();
  String? _phoneNumberError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: Get.width,
            height: Get.height,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/red_no_bg_logo.png',
                  width: Get.width * .85,
                ),
                SizedBox(height: Get.height * .05),
                Text(
                  _auth.hasUser.isTrue ? 'Welcome back!' : 'Welcome!',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _auth.hasUser.isTrue,
                  child: Center(
                    child: SizedBox(
                      width: Get.width * .55,
                      child: TextButton(
                        onPressed: () {
                          _auth.localAuthenticate();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login with biometrics",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.fingerprint,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _auth.hasUser.isTrue,
                  child: const Text("or"),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: Get.width * .8,
                    child: const Text(
                      'Enter your 10 digit phone number:',
                      style: TextStyle(color: darkGray),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                PhoneNumberInput(
                  controller: _phoneNumber,
                  errorText: _phoneNumberError,
                  onChanged: (_) {
                    setState(() {
                      _phoneNumberError = null;
                    });
                  },
                  submit: () {
                    setState(() {
                      if (_phoneNumber.text.isEmpty) {
                        _phoneNumberError = 'Please enter a number.';
                      } else if (_phoneNumber.text.length < 10) {
                        _phoneNumberError =
                            'Please enter a at least 10 digit phone number.';
                      } else {
                        _auth.isRescuer.value = false;
                        _auth.phoneNumber.value = _phoneNumber.text;
                        _auth.requestOTP();
                        _auth.pinCode.value.setText('');
                        Get.toNamed('/otp-page');
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: Get.width * .8,
                    child: const Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 10),
                        children: [
                          TextSpan(
                            text: "By Logging in you agree to our",
                          ),
                          TextSpan(
                            text: " Terms and Condition.",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Get.toNamed('/registration');
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          "Want to become a Rescuer? ",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          " Register here.",
                          style: TextStyle(fontSize: 12, color: primaryRed),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
