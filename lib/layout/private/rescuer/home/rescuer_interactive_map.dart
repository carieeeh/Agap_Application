import 'dart:async';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/rescuer_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RescuerInteractiveMap extends StatefulWidget {
  const RescuerInteractiveMap({super.key});

  @override
  State<RescuerInteractiveMap> createState() => _RescuerInteractiveMapState();
}

class _RescuerInteractiveMapState extends State<RescuerInteractiveMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final AuthController _auth = Get.find<AuthController>();
  final LocationsController _locController = Get.find<LocationsController>();
  final RescuerController _rescuerController = Get.find<RescuerController>();
  final ReportController _reportController = Get.find<ReportController>();

  CameraPosition? _kGooglePlex;
  late Position _userPosition;
  String currentAddress = "Use Current Location";
  double? lat, lng;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  Future initFunction() async {
    await _locController.checkLocationPermission();
    _reportController.getAllReports();
    _userPosition = await _locController.getUserLocation();
    _kGooglePlex = CameraPosition(
      target: LatLng(_userPosition.latitude, _userPosition.longitude),
      zoom: 15,
    );
    _rescuerController.userStation.value = await _reportController
        .getStationInfo(_auth.userModel?.department ?? "");
    currentAddress =
        await _locController.getAddressByCoordinates(_userPosition);
    await _rescuerController.updateRescuerLocation();
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
              height: Get.height * .69,
              width: Get.width,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  color: Colors.white,
                  child: Obx(
                    () => Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: _rescuerController.isLoading.isFalse,
                          child: GoogleMap(
                            style: mapStyleNoLandmarks.toString(),
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            markers: _rescuerController.markers,
                            initialCameraPosition: _kGooglePlex ??
                                const CameraPosition(
                                  target: LatLng(14.5871, 120.9845),
                                  zoom: 15,
                                ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                        Visibility(
                          visible: _rescuerController.isLoading.isTrue,
                          child: const CircularProgressIndicator(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Obx(
                () => Visibility(
                  visible: _rescuerController.hasEmergency.isTrue,
                  child: IconButton(
                    onPressed: () async {
                      _rescuerController.navigateToEmergency();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: colorSuccess,
                    ),
                    icon: const Icon(
                      Icons.navigation_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Obx(
                  () => Visibility(
                    visible: _rescuerController.hasEmergency.isTrue,
                    child: RoundedCustomButton(
                      onPressed: () {
                        _rescuerController.hasArrive.isTrue
                            ? _rescuerController.declareFinish()
                            : _rescuerController.declareArrive();
                      },
                      label: _rescuerController.hasArrive.isTrue
                          ? "Mark as finish"
                          : "Arrive at location",
                      bgColor: primaryRed,
                      size: Size(Get.width * .6, 40),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: Get.height * .25,
      color: primaryRed,
      child: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * .6,
                  child: Text(
                    _rescuerController.userStation.value.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(_auth.userModel!.profile),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _rescuerController.isOnline.isFalse,
              child: RoundedCustomButton(
                onPressed: () async {
                  await _rescuerController.updateRescuerStatus("online");
                  _rescuerController.isOnline.value = true;
                },
                isLoading: _rescuerController.isLoading.value,
                label: "Go online",
                bgColor: colorSuccess,
                size: Size(Get.width * .85, 30),
              ),
            ),
            Visibility(
              visible: _rescuerController.isOnline.isTrue,
              child: RoundedCustomButton(
                onPressed: () async {
                  await _rescuerController.updateRescuerStatus("offline");
                  _rescuerController.isOnline.value = false;
                },
                isLoading: _rescuerController.isLoading.value,
                label: "Go offline",
                bgColor: colorError,
                size: Size(Get.width * .85, 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
