import 'dart:async';
import 'dart:convert';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RescuerController extends GetxController {
  final LocationsController _locations = Get.find<LocationsController>();
  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final ReportController _report = Get.find<ReportController>();
  GeoPoint? emergencyLoc;
  Set<Marker> markers = {};
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

  Future<void> acceptEmergency(
      GeoPoint geoPoint, String residentUid, String emergencyId) async {
    try {
      await updateRescuerStatus("occupied");
      final residentInfo = jsonEncode(await _auth.findUserInfo(residentUid));
      final jsonInfo = jsonDecode(residentInfo);

      emergencyLoc = geoPoint;

      startLocationUpdate();

      markers.clear();
      markers.add(Marker(
        markerId: const MarkerId('emergency'),
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
      ));

      final data = {
        "purpose": "accepted",
        "title": "Emergency report is accepted.",
        "message": "Rescuer is on its way to your emergency.",
        "rescuer_uid": _auth.currentUser?.uid,
      };

      await _report.updateEmergency(emergencyId, {"status": "accepted"});
      await _settings.callFunction(jsonInfo["fcm_token"], data);

      Get.back();
      Get.snackbar(
        "Emergency accepted!",
        "You can navigate to your location by clicking \nthe navigation button on the map's lower right.",
        duration: const Duration(seconds: 5),
        backgroundColor: colorSuccess,
      );
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        const GetDialog(
          type: 'error',
          title: 'Login Failed',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message:
              'Error: No user found! \nPlease log out then log in your account',
        ),
      );
    }
  }

  Future navigateToEmergency() async {
    await launchUrl(
      Uri.parse(
          'google.navigation:q=${emergencyLoc!.latitude},${emergencyLoc!.longitude}&key=$googleApiKey'),
    );
  }

  Future declineEmergency() async {
    await updateRescuerStatus("free");
    markers.clear();
    Get.back();
  }
}
