import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                padding: EdgeInsets.only(left: 10),
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
                          hintStyle: TextStyle(color: lightGray),
                        ),
                        controller: _email,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/');
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
              const SizedBox(height: 20),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: SizedBox(
              //     width: Get.width * .8,
              //     child: const Text.rich(
              //       TextSpan(
              //         children: [
              //           TextSpan(
              //             text: "By Logging in you agree to our",
              //           ),
              //           TextSpan(
              //             text: " Terms and Condition.",
              //           ),
              //         ],
              //       ),
              //       textAlign: TextAlign.start,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
