import 'dart:async';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RescuerController extends GetxController {
  final LocationsController _locations = Get.find<LocationsController>();
  final AuthController _auth = Get.find<AuthController>();
  Timer? _timer;
  bool _isRunning = false;

  Future<void> updateRescuerLocation() async {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
    Position position = await _locations.getUserLocation();
    final uid = _auth.currentUser!.uid;

    final collection = await firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('rescuer_locations');

    final QuerySnapshot querySnapShot =
        await collection.where('uid', isEqualTo: uid).get();
    if (querySnapShot.docs.isEmpty) {
      await collection.add({
        "uid": uid,
        "geopoint": GeoPoint(position.latitude, position.longitude),
        "status": "free",
        "department": _auth.userModel?.department,
      });
    } else {
      querySnapShot.docs.first.reference.update(
          {"geopoint": GeoPoint(position.latitude, position.longitude)});
    }
  }

  Future<void> updateRescuerStatus(String status) async {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
    final uid = _auth.currentUser!.uid;

    final collection = await firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('rescuer_locations');
    final QuerySnapshot querySnapShot =
        await collection.where('uid', isEqualTo: uid).get();
    querySnapShot.docs.first.reference.update({"status": status});
  }

  void startLocationUpdate() {
    if (!_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        updateRescuerLocation();
        print("update driver location");
      });
      _isRunning = true;
    }
  }

  void stopLocationUpdate() {
    _timer?.cancel();
    _isRunning = false;
  }
}
