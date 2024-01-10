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
            children: [
              SizedBox(height: Get.height * .1),
              Image.asset(
                'assets/images/red_no_bg_logo.png',
                width: Get.width * .8,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
