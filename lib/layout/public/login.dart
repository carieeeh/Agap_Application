import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/underline_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: Get.height * .15),
              Image.asset(
                'assets/images/red_no_bg_logo.png',
                width: Get.width * .85,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: Get.width * .5,
                child: const Text(
                  'Welcome back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                ),
              ),
              const Text(
                'Login to continue...',
                style: TextStyle(
                  color: gray,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  UnderlineInput(
                    label: 'E-mail',
                    isPassword: false,
                    icon: Icons.mail,
                    textController: _email,
                  ),
                  UnderlineInput(
                    label: 'Password',
                    isPassword: true,
                    icon: Icons.visibility,
                    textController: _password,
                  ),
                  const SizedBox(height: 25),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.toNamed('/registration');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create new account?',
                          style: TextStyle(color: gray),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Register here.',
                          style: TextStyle(color: primaryRed),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  RoundedCustomButton(
                    onPressed: () {},
                    label: 'Login',
                    size: Size(Get.width, 40),
                    bgColor: primaryRed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
