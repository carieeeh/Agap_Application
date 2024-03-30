import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
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
  final AuthController _authService = Get.find<AuthController>();
  final TextEditingController _firstName = TextEditingController();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 130),
                  Center(
                    child: Image.asset(
                      'assets/images/red_no_bg_logo.png',
                      width: Get.width * .5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign up as rescuer in our App: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color:
                      //         Colors.grey.withOpacity(0.5), // Color of the shadow
                      //     spreadRadius: 2, // Spread radius
                      //     blurRadius: 2, // Blur radius
                      //     offset: const Offset(4, 4), // Offset (x, y)
                      //   )
                      // ],
                    ),
                    child: Column(
                      children: [
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
                  RoundedCustomButton(
                    onPressed: () {
                      _authService.isRescuer.value = true;
                      Get.offNamed('/interactive_map');
                    },
                    label: 'Sign up',
                    size: Size(Get.width, 40),
                    bgColor: primaryRed,
                  ),
                  const Center(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 10),
                        children: [
                          TextSpan(
                            text: "By Sining up you agree to our",
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
