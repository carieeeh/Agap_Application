import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: Get.height * .25),
              Image.asset(
                'assets/images/red_no_bg_logo.png',
                width: Get.width * .85,
              ),
              SizedBox(height: Get.height * .05),
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: Get.width * .8,
                  child: const Text(
                    'Enter your 10 digit phone number:',
                    style: TextStyle(
                      color: darkGray,
                      fontSize: 16,
                    ),
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
              const SizedBox(height: 10),
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
                    textAlign: TextAlign.start,
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
    );
  }
}
