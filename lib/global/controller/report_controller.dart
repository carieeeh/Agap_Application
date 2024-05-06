import 'dart:convert';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/global/controller/storage_controller.dart';
import 'package:agap_mobile_v01/global/model/emergency.dart';
import 'package:agap_mobile_v01/global/model/station.dart';
import 'package:agap_mobile_v01/global/model/user_model.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReportController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final StorageController _storageController = Get.find<StorageController>();
  RxList emergencies = [].obs;

  RxBool isLoading = false.obs;
  Rx<UserModel> rescuerData = UserModel().obs;
  Rx<Station> stationData = Station().obs;

  Future<DocumentSnapshot?> sendEmergencyReport({
    required List<XFile> files,
    required String type,
    required String description,
    required String address,
    required double lat,
    required double lng,
  }) async {
    isLoading.value = true;
    try {
      await _auth.getCurrentUser();
      FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
      List<String> imageUrls = [];

      for (var file in files) {
        imageUrls.add(await _storageController.uploadFile(file, "reports"));
      }

      if (imageUrls.isNotEmpty) {
        Emergency emergency = Emergency(
          residentUid: _auth.currentUser!.uid,
          description: description,
          geopoint: GeoPoint(lat, lng),
          type: type,
          address: address,
          totalUnits: 1,
          status: 'pending',
          fileUrls: imageUrls,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );

        DocumentReference docRef = await firestoreDb
            .collection("agap_collection")
            .doc(fireStoreDoc)
            .collection('emergencies')
            .add(emergency.toJson());
        DocumentSnapshot doc = await docRef.get();
        return doc;
      }
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Report Failed',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error code: $error',
        ),
      );
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> getUserReports() async {
    try {
      isLoading.value = true;

      FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
      final result = await firestoreDb
          .collection("agap_collection")
          .doc('staging')
          .collection('emergencies')
          .get();

      emergencies.value = result.docs;
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Failed reading emergencies',
          hasMessage: true,
          buttonNumber: 0,
          hasCustomWidget: false,
          withCloseButton: true,
          message: 'Error code: $error',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmergency(String docId, Map<String, dynamic> data) async {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

    await firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('emergencies')
        .doc(docId)
        .update(data);
  }

  Future<void> getRescuerInfo(String uid) async {
    final data = jsonEncode(await _auth.findUserInfo(uid));
    rescuerData.value = UserModel.fromJson(jsonDecode(data));

    stationData.value = await getStationInfo(rescuerData.value.department);
  }

  Future<Station> getStationInfo(String? stationCode) async {
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

    QuerySnapshot querySnapShot = await firestoreDb
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection('stations')
        .where('station_code', isEqualTo: stationCode)
        .get();

    return Station.fromJson(
      jsonDecode(
        jsonEncode(querySnapShot.docs.first.data()),
      ),
    );
  }

  Stream<DocumentSnapshot> getRescuerLoc(String uid) {
    // uid = "vHtpu0MBreXEmStOCwihxtpDpOv1";

    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> rescuerLocations = firestoreDb
        .collection("agap_collection")
        .doc('staging')
        .collection('rescuer_locations');

    return rescuerLocations
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception('No document found');
      }
    });
  }

  Future sendEmergencyFeedback(
    double? rating,
    String emergencyId,
    String comment,
    String role,
  ) async {
    try {
      isLoading.value = true;
      await _auth.getCurrentUser();
      FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

      final data = {
        "emergency_id": emergencyId,
        "comment": comment,
        "role": role,
        "rating": rating,
      };

      await firestoreDb
          .collection("agap_collection")
          .doc(fireStoreDoc)
          .collection('emergency_feedbacks')
          .add(data);

      Get.snackbar(
        "Feedback submitted",
        _auth.isRescuer.isTrue
            ? "Thank you for writing a feedback"
            : "Thank you for writing a feedback,\n you earn 1 AGAP Points",
        duration: const Duration(seconds: 5),
        backgroundColor: colorSuccess,
      );

      if (_auth.isRescuer.isFalse) {
        final uid = _auth.currentUser!.uid;

        final collection = firestoreDb
            .collection("agap_collection")
            .doc(fireStoreDoc)
            .collection('user_badges');

        final QuerySnapshot querySnapShot =
            await collection.where('uid', isEqualTo: uid).get();
        if (querySnapShot.docs.isEmpty) {
          await collection.add({
            "uid": uid,
            "badges": [],
            "agap_points": 1,
          });
        } else {
          final agapData = querySnapShot.docs.first.data();
          final dataToJson = jsonEncode(agapData);
          final jsonInfo = jsonDecode(dataToJson);
          final totalPoints = jsonInfo["agap_points"] ?? 1;

          querySnapShot.docs.first.reference
              .update({"agap_points": totalPoints + 1});
        }
        _settings.hasReport.value = false;
        Get.offNamed("/home");
      }
    } catch (error) {
      Get.dialog(
        barrierDismissible: false,
        GetDialog(
          type: 'error',
          title: 'Feedback Failed',
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
}
