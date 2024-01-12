import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/underline_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/images/red_no_bg_logo.png',
                  width: Get.width * .5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sign up to start using our App: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              UnderlineInput(
                label: 'First Name',
                isPassword: false,
                textController: _firstName,
              ),
              UnderlineInput(
                label: 'Middle Name',
                isPassword: false,
                textController: _firstName,
              ),
              UnderlineInput(
                label: 'Last Name',
                isPassword: false,
                textController: _firstName,
              ),
              UnderlineInput(
                label: 'Contact No.',
                isPassword: false,
                textController: _firstName,
              ),
              UnderlineInput(
                label: 'Emergency Contact No.',
                isPassword: false,
                textController: _firstName,
              ),
              UnderlineInput(
                label: 'Email',
                isPassword: false,
                textController: _firstName,
              ),
              const SizedBox(height: 40),
              RoundedCustomButton(
                onPressed: () {},
                label: 'Sign up',
                size: Size(Get.width, 40),
                bgColor: primaryRed,
              ),
              Center(
                child: SizedBox(
                  width: Get.width * .8,
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "By Singing up you agree to our",
                        ),
                        TextSpan(
                          text: " Terms and Condition.",
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
