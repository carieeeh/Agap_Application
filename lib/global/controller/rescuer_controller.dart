import 'dart:async';
import 'dart:convert';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/locations_controller.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/global/model/station.dart';
import 'package:agap_mobile_v01/layout/private/resident/reports/report_feedback.dart';
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
  RxBool isLoading = false.obs,
      hasEmergency = false.obs,
      hasArrive = false.obs,
      isRequested = false.obs,
      isOnline = false.obs;
  String _residentUid = "", emergencyDocId = "";
  Rx<Station> userStation = Station().obs;

  Future<void> updateRescuerLocation(String status) async {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
    Position position = await _locations.getUserLocation();
    final uid = _auth.currentUser!.uid;

    final collection = firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('rescuer_locations');

    final QuerySnapshot querySnapShot =
        await collection.where('uid', isEqualTo: uid).get();
    if (querySnapShot.docs.isEmpty) {
      await collection.add({
        "uid": uid,
        "geopoint": GeoPoint(position.latitude, position.longitude),
        "status": status,
        "department": _auth.userModel?.department,
      });
    } else {
      querySnapShot.docs.first.reference.update({
        "geopoint": GeoPoint(position.latitude, position.longitude),
        "department": _auth.userModel?.department,
        "status": status,
      });
    }
  }

  Future<void> updateRescuerStatus(String status) async {
    isLoading.value = true;
    try {
      FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
      final uid = _auth.currentUser!.uid;

      final collection = firestoreDb
          .collection("agap_collection")
          .doc(fireStoreDoc)
          .collection('rescuer_locations');
      final QuerySnapshot querySnapShot =
          await collection.where('uid', isEqualTo: uid).get();
      querySnapShot.docs.first.reference.update({"status": status});
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Something went wrong',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error: $error',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startLocationUpdate() {
    if (!_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        updateRescuerLocation("occupied");
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
      isLoading.value = true;
      _residentUid = residentUid;
      emergencyDocId = emergencyId;
      markers.clear();
      markers.add(Marker(
        markerId: const MarkerId('emergency'),
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
      ));
      await updateRescuerStatus("occupied");
      final residentInfo = jsonEncode(await _auth.findUserInfo(residentUid));
      final jsonInfo = jsonDecode(residentInfo);

      emergencyLoc = geoPoint;

      startLocationUpdate();

      final data = {
        "purpose": "accepted",
        "title": "Emergency report is accepted.",
        "message": "Rescuer is on its way to your emergency.",
        "rescuer_uid": _auth.currentUser?.uid,
      };

      await _report.updateEmergency(emergencyId, {"status": "accepted"});
      await _settings.callFunction(jsonInfo["fcm_token"], data);
      hasEmergency.value = true;
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
        GetDialog(
          type: 'error',
          title: 'Something went wrong',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error: ${error.toString()}',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future navigateToEmergency() async {
    await launchUrl(
      Uri.parse(
          'google.navigation:q=${emergencyLoc!.latitude},${emergencyLoc!.longitude}&key=$googleApiKey'),
    );
  }

  Future declineEmergency() async {
    try {
      isLoading.value = true;
      await updateRescuerStatus("free");
      markers.clear();
      Get.back();
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Something went wrong',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error: ${error.toString()}',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future declareArrive() async {
    try {
      isLoading.value = true;
      final residentInfo = jsonEncode(await _auth.findUserInfo(_residentUid));
      final jsonInfo = jsonDecode(residentInfo);

      final data = {
        "purpose": "arrive",
        "title": "Rescuer arrive at your location.",
        "message": "Rescuer is on its way to your emergency.",
        "rescuer_uid": _auth.currentUser?.uid,
      };

      await _report.updateEmergency(emergencyDocId, {"status": "ongoing"});
      await _settings.callFunction(jsonInfo["fcm_token"], data);
      hasArrive.value = true;
      stopLocationUpdate();
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Something went wrong',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error: ${error.toString()}',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future declareFinish() async {
    try {
      isLoading.value = true;

      await updateRescuerStatus("online");
      markers.clear();
      final residentInfo = jsonEncode(await _auth.findUserInfo(_residentUid));
      final jsonInfo = jsonDecode(residentInfo);

      final data = {
        "purpose": "finish",
        "title": "Emergency finish.",
        "message": "Rescuer marks your emergency as finish.",
        "emergency_id": emergencyDocId,
        "rescuer_uid": _auth.currentUser?.uid,
      };

      await _report.updateEmergency(emergencyDocId, {"status": "finished"});
      await _settings.callFunction(jsonInfo["fcm_token"], data);
      hasArrive.value = true;
      hasEmergency.value = false;
      stopLocationUpdate();
      Get.to(ReportFeedback(
        emergencyDocId: emergencyDocId,
        userUid: _residentUid,
        role: "rescuer",
      ));
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Something went wrong',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error: ${error.toString()}',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // void rescuerHandleMessaging() {
  //   if(_auth.isRescuer.isTrue) {
  //     if (message.data.containsKey("purpose") &&
  //           message.data["purpose"] == "rescuer" &&
  //           _auth.isRescuer.isTrue) {
  //         final emergency = jsonDecode(message.data["emergency"]);

  //         List<String> fileUrls = emergency["file_urls"].cast<String>();

  //         Get.dialog(
  //           barrierDismissible: false,
  //           RescuerDialog(
  //             imageUrls: fileUrls,
  //             type: emergency["type"],
  //             location: emergency["address"],
  //             totalUnits: emergency["total_units"].toString(),
  //             description: emergency["description"],
  //             residentUid: emergency["resident_uid"],
  //             geoPoint: GeoPoint(
  //               emergency["geopoint"]["latitude"],
  //               emergency["geopoint"]["longitude"],
  //             ),
  //             emergencyId: emergency["docId"],
  //           ),
  //         );
  //       }
  //   }
  // }
}
