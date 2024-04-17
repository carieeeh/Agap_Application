import 'dart:async';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/rescuer_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:agap_mobile_v01/layout/widgets/google_maps/google_places_view.dart';
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

  final LocationsController _locController = Get.find<LocationsController>();
  final RescuerController _rescuerController = Get.find<RescuerController>();
  final AuthController _authController = Get.find<AuthController>();

  CameraPosition? _kGooglePlex;
  late Position _userPosition;
  String currentAddress = "Use Current Location";
  String? _incidentAddress;
  double? lat, lng;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  Future initFunction() async {
    await _locController.checkLocationPermission();
    _userPosition = await _locController.getUserLocation();
    _kGooglePlex = CameraPosition(
      target: LatLng(_userPosition.latitude, _userPosition.longitude),
      zoom: 15,
    );
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
            Container(
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
                          Text(
                            _authController.userModel!.department ?? "",
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
                    onTap: () async {
                      _locController.isLoading.value = true;
                      var googleResult = await Get.to(() => GooglePlacesView());

                      if (googleResult != null) {
                        _incidentAddress = googleResult['description'];
                        lat = googleResult['lat'] as double;
                        lng = googleResult['lng'] as double;
                      } else {
                        _incidentAddress = currentAddress;
                        lat = _userPosition.latitude;
                        lng = _userPosition.longitude;
                      }
                      _locController.isLoading.value = false;
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
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
            ),
            Positioned(
              bottom: 0,
              height: Get.height * .71,
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
}
