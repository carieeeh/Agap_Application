import 'dart:io';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/emergency_button.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ReportController _reportController = Get.find<ReportController>();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _reportDescriptionController =
      TextEditingController();
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
                      onPressed: () {
                        _takeImageReport('earthquake');
                      },
                      title: 'Earthquake',
                      imagePath: 'assets/images/earthquake.gif',
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        EmergencyButton(
                          onPressed: () {
                            _takeImageReport('medical');
                          },
                          title: 'Medical',
                          imagePath: 'assets/images/medicine.gif',
                        ),
                        EmergencyButton(
                          onPressed: () {
                            _takeImageReport('fire');
                          },
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
                          onPressed: () {
                            _takeImageReport('police');
                          },
                          title: 'Police',
                          imagePath: 'assets/images/security-guard.gif',
                        ),
                        EmergencyButton(
                          onPressed: () {
                            _takeImageReport('flood');
                          },
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

  Future _takeImageReport(String type) async {
    photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (photo != null) {
      Get.dialog(
        Dialog(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Verify your report:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Text(
                        "Are you sure you want to send this picture as your report?",
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Image.file(
                          File(photo!.path),
                          height: 300,
                          width: 300,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: colorSuccess,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: colorSuccess),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            Text(
                              'Add image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: _reportDescriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Description... (optional)',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedCustomButton(
                            onPressed: () {
                              _reportController
                                  .sendEmergencyReport(
                                file: photo!,
                                type: type,
                                description: _reportDescriptionController.text,
                              )
                                  .then((value) {
                                if (value != null) {
                                  Get.back();
                                  Get.snackbar(
                                    "Success: Report Successfully Submitted",
                                    "You successfully submit a report!",
                                    backgroundColor: colorSuccess,
                                    colorText: Colors.white,
                                  );
                                  _reportDescriptionController.setText('');
                                } else {
                                  Get.dialog(
                                    barrierDismissible: false,
                                    const GetDialog(
                                      type: 'error',
                                      title: 'Report Failed',
                                      hasMessage: true,
                                      buttonNumber: 0,
                                      hasCustomWidget: false,
                                      withCloseButton: true,
                                      message: 'Please try again.',
                                    ),
                                  );
                                }
                              });
                            },
                            label: "Yes",
                            size: const Size(100, 50),
                            bgColor: primaryRed,
                          ),
                          const SizedBox(width: 10),
                          RoundedCustomButton(
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
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  child: Obx(
                    () => Visibility(
                      visible: _reportController.isLoading.isTrue,
                      child: Container(
                        height: Get.height * .8,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sending report...',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
