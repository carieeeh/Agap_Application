import 'package:cloud_firestore/cloud_firestore.dart';

class Emergency {
  String? address;
  String? description;
  List<String>? fileUrls;
  List<String>? rescuerUids;
  GeoPoint? geopoint;
  String? residentUid;
  String? status;
  int? totalUnits;
  String? type;
  Timestamp createdAt = Timestamp.now();
  Timestamp updatedAt = Timestamp.now();

  Emergency({
    this.address,
    this.fileUrls,
    this.rescuerUids,
    this.geopoint,
    this.residentUid,
    this.status,
    this.totalUnits,
    this.type,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Emergency.fromJson(Map<String, dynamic>? json) {
    return Emergency(
      address: json?['address'],
      description: json?['address'],
      fileUrls: (json?['file_urls'] as List?)?.map((e) => e as String).toList(),
      rescuerUids:
          (json?['rescuer_uids'] as List?)?.map((e) => e as String).toList(),
      residentUid: json?['resident_uid'],
      geopoint: json?['geopoint'],
      status: json?['status'],
      totalUnits: json?['total_units'],
      type: json?['type'],
      createdAt: json?['created_at'],
      updatedAt: json?['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'created_at': createdAt,
      'file_urls': fileUrls,
      'description': description,
      'geopoint': geopoint,
      'rescuer_uids': rescuerUids,
      'resident_uid': residentUid,
      'status': status,
      'total_units': totalUnits,
      'type': type,
      'updated_at': updatedAt,
    };
  }
}
