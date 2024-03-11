import 'package:cloud_firestore/cloud_firestore.dart';

class Emergency {
  String? address;
  DateTime? createdAt;
  String? description;
  List<String>? fileUrls;
  List<String>? rescuerUids;
  GeoPoint? geopoint;
  String? residentUid;
  String? status;
  int? totalUnits;
  String? type;
  DateTime? updatedAt;

  Emergency({
    this.address,
    this.createdAt,
    this.fileUrls,
    this.rescuerUids,
    this.geopoint,
    this.residentUid,
    this.status,
    this.totalUnits,
    this.type,
    this.updatedAt,
    this.description,
  });

  factory Emergency.fromJson(Map<String, dynamic>? json) {
    return Emergency(
      address: json?['address'],
      createdAt: json?['created_at'] != null
          ? DateTime.parse(json?['created_at'])
          : null,
      description: json?['address'],
      fileUrls: (json?['file_urls'] as List?)?.map((e) => e as String).toList(),
      rescuerUids:
          (json?['rescuer_uids'] as List?)?.map((e) => e as String).toList(),
      residentUid: json?['resident_uid'],
      geopoint: json?['geopoint'],
      status: json?['status'],
      totalUnits: json?['total_units'],
      type: json?['type'],
      updatedAt: json?['updated_at'] != null
          ? DateTime.parse(json?['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'created_at': createdAt?.toUtc().toString(),
      'file_urls': fileUrls,
      'description': description,
      'geopoint': geopoint,
      'rescuer_uids': rescuerUids,
      'resident_uid': residentUid,
      'status': status,
      'total_units': totalUnits,
      'type': type,
      'updated_at': updatedAt?.toUtc().toString(),
    };
  }
}
