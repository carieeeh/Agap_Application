import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/underline_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      _email = TextEditingController();

  String? _department;

  final List _list = [
    {"label": "Fire Department", "value": "fire"},
    {"label": "Police Department", "value": "police"},
    {"label": "Medical Department", "value": "medic"},
    {"label": "Barangay Department", "value": "Barangay"},
  ];

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
                      DropdownMenu<dynamic>(
                        width: Get.width * .8,
                        hintText: "Select your department",
                        textStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 13),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        onSelected: (item) {
                          _department = item;
                          setState(() {});
                        },
                        menuStyle: const MenuStyle(
                          surfaceTintColor:
                              MaterialStatePropertyAll(Colors.white),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        dropdownMenuEntries:
                            _list.map<DropdownMenuEntry>((dynamic item) {
                          return DropdownMenuEntry(
                            value: item["value"],
                            label: item["label"],
                            labelWidget: Text(
                              item["label"],
                              style: const TextStyle(fontSize: 14),
                            ),
                            style: const ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => RoundedCustomButton(
                    onPressed: () {
                      _auth.rescuerRegister(
                        firstName: _firstName.text,
                        middleName: _middleName.text,
                        lastName: _lastName.text,
                        contactNumber: _contactNumber.text,
                        emeContactNumber: _emeContactNumber.text,
                        email: _email.text,
                        department: _department ?? "",
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
          ),
        ),
      ),
    );
  }
}
