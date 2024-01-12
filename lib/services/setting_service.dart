import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SettingService extends GetxService {
  late Rx<Position> currentPosstion;

  Future<SettingService> init() async {
    await _determinePosition().then((value) {
      currentPosstion = value.obs;
    });
    log(currentPosstion.value.toString());
    return this;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
