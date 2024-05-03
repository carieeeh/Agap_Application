import 'dart:async';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RescuerMapView extends StatefulWidget {
  const RescuerMapView({super.key});

  @override
  State<RescuerMapView> createState() => _RescuerMapViewState();
}

class _RescuerMapViewState extends State<RescuerMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final LocationsController _locController = Get.find<LocationsController>();
  final ReportController _reportController = Get.find<ReportController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  late Position _userPosition;
  CameraPosition? _kGooglePlex;
  BitmapDescriptor rescuerIcon = BitmapDescriptor.defaultMarker;
  Set<Marker> markers = {};

  final TextStyle labelStyle =
      const TextStyle(fontSize: 14, color: Colors.white);
  final TextStyle detailsStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  late Timer timer;
  LatLng rescuerPosition = const LatLng(14.5871, 120.9845);

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  Future initFunction() async {
    _reportController.isLoading.value = true;
    await _locController.checkLocationPermission();
    _userPosition = await _locController.getUserLocation();

    _kGooglePlex = CameraPosition(
      target: LatLng(_userPosition.latitude, _userPosition.longitude),
      zoom: 15,
    );
    await _reportController
        .getRescuerInfo(_settingsController.rescuerUid.value);
    rescuerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/rescuer_icon.png");
    _reportController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Rescuer location",
      body: SafeArea(
          child: Stack(
        children: [
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: primaryRed,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * .35,
                        child: Text("Station name :", style: labelStyle),
                      ),
                      Expanded(
                        child: Text(
                          _reportController.stationData.value.name ?? "",
                          style: detailsStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * .35,
                        child: Text("Contact :", style: labelStyle),
                      ),
                      Expanded(
                        child: Text(
                          _reportController.stationData.value.contact ?? "",
                          style: detailsStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * .35,
                        child: Text("Arrival time :", style: labelStyle),
                      ),
                      Expanded(
                        child: Text(
                          _reportController.rescuerData.value.department ?? "",
                          style: detailsStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            height: Get.height * .75,
            width: Get.width,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Container(
                color: Colors.white,
                child: StreamBuilder<DocumentSnapshot?>(
                  stream: _reportController
                      .getRescuerLoc(_settingsController.rescuerUid.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final DocumentSnapshot document = snapshot.data!;
                      final GeoPoint geoPoint = document["geopoint"];

                      return Obx(
                        () => Visibility(
                          visible: _reportController.isLoading.isFalse,
                          child: GoogleMap(
                            style: mapStyleNoLandmarks.toString(),
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            initialCameraPosition: _kGooglePlex ??
                                const CameraPosition(
                                  target: LatLng(14.5871, 120.9845),
                                  zoom: 15,
                                ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('rescuer'),
                                icon: rescuerIcon,
                                position: LatLng(
                                    geoPoint.latitude, geoPoint.longitude),
                              )
                            },
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
