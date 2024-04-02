import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/storage_controller.dart';
import 'package:agap_mobile_v01/global/model/emergency.dart';
import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReportController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final StorageController _storageController = Get.find<StorageController>();
  RxBool isLoading = false.obs;

  Future<DocumentSnapshot?> sendEmergencyReport({
    required XFile file,
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
      String? imageUrl = await _storageController.uploadFile(file);

      if (imageUrl != null) {
        Emergency emergency = Emergency(
          residentUid: _authController.currentUser!.uid,
          description: description,
          geopoint: GeoPoint(lat, lng),
          type: type,
          address: address,
          totalUnits: 1,
          status: 'pending',
          fileUrls: [imageUrl],
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
      value.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    });
  }
}
