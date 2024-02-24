import 'dart:io';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/emergency_button.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? photo;

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "",
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            Container(
              height: Get.height * .25,
              color: primaryRed,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WELCOME,",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "User Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/person.png',
                          fit: BoxFit.cover,
                          height: 45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.my_location_outlined),
                        SizedBox(width: 10),
                        Text("Use Current Location"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              height: Get.height * .7,
              width: Get.width,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "CLICK IN CASE OF EMERGENCY!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    EmergencyButton(
                      onPressed: _takeImageReport,
                      title: 'Earthquake',
                      imagePath: 'assets/images/earthquake.gif',
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        EmergencyButton(
                          onPressed: _takeImageReport,
                          title: 'Medical',
                          imagePath: 'assets/images/medicine.gif',
                        ),
                        EmergencyButton(
                          onPressed: _takeImageReport,
                          title: 'Fire',
                          imagePath: 'assets/images/fire.gif',
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        EmergencyButton(
                          onPressed: _takeImageReport,
                          title: 'Police',
                          imagePath: 'assets/images/security-guard.gif',
                        ),
                        EmergencyButton(
                          onPressed: _takeImageReport,
                          title: 'Flood',
                          imagePath: 'assets/images/floods.gif',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _takeImageReport() async {
    photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (photo != null) {
      Get.defaultDialog(
        title: "Verify your report:",
        content: Column(
          children: [
            const Text(
              "Are you sure you want to send this picture as your report?",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.file(File(photo!.path)),
            ),
          ],
        ),
        confirm: RoundedCustomButton(
          onPressed: () {
            Get.back();
            Get.snackbar(
              "Success: Report Successfully Submitted",
              "You successfully submit a report!",
              backgroundColor: colorSuccess,
              colorText: Colors.white,
            );
          },
          label: "Yes",
          size: const Size(100, 50),
          bgColor: primaryRed,
        ),
        cancel: RoundedCustomButton(
          onPressed: () {
            Get.back();
            Get.snackbar(
              "Warning: No report submitted",
              "You did not submit your report!",
              backgroundColor: yellow,
            );
          },
          label: "No",
          size: const Size(100, 50),
          bgColor: gray,
        ),
      );
    } else {
      Get.snackbar(
        "Warning: No image taken",
        "You did not take any image with your camera!",
        backgroundColor: yellow,
      );
    }
  }
}
