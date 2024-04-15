import 'dart:convert';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/storage_controller.dart';
import 'package:agap_mobile_v01/global/model/emergency.dart';
import 'package:agap_mobile_v01/global/model/user_model.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReportController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final StorageController _storageController = Get.find<StorageController>();
  RxBool isLoading = false.obs;
  Rx<UserModel> rescuerData = UserModel().obs;

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
      await _authController.getCurrentUser();
      FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
      List<String> imageUrls = [];

      for (var file in files) {
        imageUrls.add(await _storageController.uploadFile(file));
      }

      if (imageUrls.isNotEmpty) {
        Emergency emergency = Emergency(
          residentUid: _authController.currentUser!.uid,
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
    FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> emergenciesCollection =
        firestoreDb
            .collection("agap_collection")
            .doc('staging')
            .collection('emergencies');

    emergenciesCollection
        .where('resident_uid', isEqualTo: _authController.currentUser!.uid)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        print('${doc.id} => ${doc.data()}');
      }
    });
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
    final data = jsonEncode(await _authController.findUserInfo(uid));
    rescuerData.value = UserModel.fromJson(jsonDecode(data));

    print(rescuerData.value);
  }

  Stream<DocumentSnapshot> getRescuerLoc(String uid) {
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
      await _authController.getCurrentUser();
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
