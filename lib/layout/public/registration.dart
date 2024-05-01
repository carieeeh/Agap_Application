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
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController _firstName = TextEditingController(),
      _middleName = TextEditingController(),
      _lastName = TextEditingController(),
      _contactNumber = TextEditingController(),
      _emeContactNumber = TextEditingController(),
      _stationCode = TextEditingController(),
      _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
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
                const SizedBox(height: 30),
                const Text(
                  "Sign up as rescuer in our App: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      UnderlineInput(
                        label: 'Station code',
                        isPassword: false,
                        textController: _stationCode,
                      ),
                      UnderlineInput(
                        label: 'First Name',
                        isPassword: false,
                        textController: _firstName,
                      ),
                      UnderlineInput(
                        label: 'Middle Name',
                        isPassword: false,
                        textController: _middleName,
                      ),
                      UnderlineInput(
                        label: 'Last Name',
                        isPassword: false,
                        textController: _lastName,
                      ),
                      UnderlineInput(
                        label: 'Contact No.',
                        hintText: '9928372321',
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        isPassword: false,
                        textController: _contactNumber,
                      ),
                      UnderlineInput(
                        label: 'Emergency Contact No.',
                        hintText: '9928372321',
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        isPassword: false,
                        textController: _emeContactNumber,
                      ),
                      UnderlineInput(
                        label: 'Email',
                        hintText: 'example@email.com',
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                        textController: _email,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Obx(
                  () => RoundedCustomButton(
                    onPressed: () {
                      _auth.rescuerRegister(
                        stationCode: _stationCode.text,
                        firstName: _firstName.text,
                        middleName: _middleName.text,
                        lastName: _lastName.text,
                        contactNumber: _contactNumber.text,
                        emeContactNumber: _emeContactNumber.text,
                        email: _email.text,
                      );
                    },
                    isLoading: _auth.isLoading.isTrue,
                    label: 'Sign up',
                    size: Size(Get.width, 40),
                    bgColor: primaryRed,
                  ),
                ),
                const Center(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 10),
                      children: [
                        TextSpan(
                          text: "By signing up you agree to our",
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
          ),
        ),
      ),
    );
  }
}
