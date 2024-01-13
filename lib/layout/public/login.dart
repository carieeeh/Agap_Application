import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = Get.find<AuthService>();
  final TextEditingController _email = TextEditingController();

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
                    'Enter your e-mail or phone number:',
                    style: TextStyle(
                      color: darkGray,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: gray),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: Get.width * .70,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '+639892837232',
                          hintStyle: TextStyle(color: gray),
                        ),
                        controller: _email,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _authService.isRescuer.value = false;
                          Get.offNamed('/');
                          // : Get.toNamed('/interactive_map');
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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
