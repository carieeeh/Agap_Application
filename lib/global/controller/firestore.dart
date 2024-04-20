import 'package:agap_mobile_v01/global/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DBFireStoreController extends GetxController {
  final db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> getCollectionReference(
      {required String collectionName}) {
    return db
        .collection("agap_collection")
        .doc(fireStoreDoc)
        .collection(collectionName);
  }
}
