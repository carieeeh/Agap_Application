import 'dart:io';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/resident_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/google_maps/google_places_view.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/emergency_button.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final ReportController _reportController = Get.find<ReportController>();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _reportDescriptionController =
      TextEditingController();
  final LocationsController _locController = Get.find<LocationsController>();
  final ResidentController _residentController = Get.find<ResidentController>();

  late Position _incidentPosition;
  String currentAddress = "Use Current Location";
  String? _incidentAddress;
  double? lat, lng;
  List<XFile> photoList = [];
  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    initFunction();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  Future initFunction() async {
    await _locController.checkLocationPermission();
    _incidentPosition = await _locController.getUserLocation();
    await _residentController.getUserCurrentPoints();
    currentAddress =
        await _locController.getAddressByCoordinates(_incidentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "",
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            header(),
            Positioned(
              bottom: 0,
              height: Get.height * .70,
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
                        _sendReport('earthquake');
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
                            _sendReport('medical');
                          },
                          title: 'Health care',
                          imagePath: 'assets/images/medicine.gif',
                        ),
                        EmergencyButton(
                          onPressed: () {
                            _sendReport('fire');
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
                            _sendReport('police');
                          },
                          title: 'Police',
                          imagePath: 'assets/images/security-guard.gif',
                        ),
                        EmergencyButton(
                          onPressed: () {
                            _sendReport('flood');
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

  Future _sendReport(String type) async {
    await takeImage();
    if (photoList.isNotEmpty) {
      Get.dialog(
        Dialog(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                reportForm(type),
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
    }
  }

  Widget header() {
    return Container(
      height: Get.height * .25,
      color: primaryRed,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "WELCOME,",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _authController.userModel!.fullName(),
                    style: const TextStyle(
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
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              openSearchLocation();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(
                () => Row(
                  children: [
                    const Icon(Icons.my_location_outlined),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: _locController.isLoading.isFalse,
                      child: SizedBox(
                        width: Get.width * .75,
                        child: Text(
                          _incidentAddress ?? currentAddress,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _locController.isLoading.isTrue,
                      child: SizedBox(
                        width: Get.width * .75,
                        child: const LinearProgressIndicator(
                          color: bgPrimaryBlue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget reportForm(String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Verify your report:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(
            "Are you sure you want to send this picture as your report?",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Get.height * .5,
            width: Get.width,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageViewController,
                  itemCount: photoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Image.file(
                        File(photoList[index].path),
                        height: 280,
                        width: 280,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Get.back();
              _sendReport(type);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: colorSuccess,
              side: const BorderSide(color: colorSuccess),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white),
                Text(
                  'Add image ${photoList.length}',
                  style: const TextStyle(color: Colors.white),
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
                  onReportConfirm(type);
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
                  setState(() {
                    photoList = [];
                    _reportDescriptionController.text = '';
                  });
                },
                label: "No",
                size: const Size(100, 50),
                bgColor: gray,
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> takeImage() async {
    final photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (photo != null) {
      photoList.add(photo);
    } else {
      Get.snackbar(
        "Warning: No image taken",
        "You did not take any image with your camera!",
        backgroundColor: yellow,
      );
    }
  }

  void onReportConfirm(String type) {
    _reportController
        .sendEmergencyReport(
      files: photoList,
      type: type,
      description: _reportDescriptionController.text,
      address: _incidentAddress ?? currentAddress,
      lat: lat ?? _incidentPosition.latitude,
      lng: lng ?? _incidentPosition.longitude,
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

    setState(() {
      photoList = [];
      _reportDescriptionController.text = '';
    });
  }

  Future<void> openSearchLocation() async {
    _locController.isLoading.value = true;
    var googleResult = await Get.to(() => GooglePlacesView());

    if (googleResult != null) {
      _incidentAddress = googleResult['description'];
      lat = googleResult['lat'] as double;
      lng = googleResult['lng'] as double;
    } else {
      _incidentAddress = currentAddress;
      lat = _incidentPosition.latitude;
      lng = _incidentPosition.longitude;
    }
  }
}
