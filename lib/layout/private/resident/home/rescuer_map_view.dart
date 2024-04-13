import 'dart:async';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
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
  late Position _userPosition;
  CameraPosition? _kGooglePlex;
  BitmapDescriptor rescuerIcon = BitmapDescriptor.defaultMarker;

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
    await _locController.checkLocationPermission();
    _userPosition = await _locController.getUserLocation();
    _kGooglePlex = CameraPosition(
      target: LatLng(_userPosition.latitude, _userPosition.longitude),
      zoom: 15,
    );
    rescuerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/rescuer_icon.png");
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      // Update marker position every 3 seconds
      setState(() {
        rescuerPosition = LatLng(
          rescuerPosition.latitude +
              0.001, // Example: Increment latitude by 0.01
          rescuerPosition.longitude +
              0.001, // Example: Increment longitude by 0.01
        );
      });
    });
    Timer.periodic(Duration(seconds: 30), (_) {
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Rescuer location",
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: primaryRed,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * .30,
                      child: Text("Rescuer name :", style: labelStyle),
                    ),
                    Expanded(
                      child: Text(
                        "Reydan John Belen",
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
                      width: Get.width * .30,
                      child: Text("Contact no. :", style: labelStyle),
                    ),
                    Expanded(
                      child: Text(
                        "09321321321",
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
                      width: Get.width * .30,
                      child: Text("Department :", style: labelStyle),
                    ),
                    Expanded(
                      child: Text(
                        "Fire Department",
                        style: detailsStyle,
                      ),
                    ),
                  ],
                ),
              ],
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
                child: Obx(
                  () => Visibility(
                    visible: _locController.isLoading.isFalse,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      initialCameraPosition: _kGooglePlex ??
                          const CameraPosition(
                            target: LatLng(14.5871, 120.9845),
                          ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('rescuer'),
                          icon: rescuerIcon,
                          position: rescuerPosition,
                        )
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
