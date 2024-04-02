import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? firstName;
  String? middleName;
  String? lastName;
  String? role;
  String? contactNumber;
  String? emeContactNumber;
  String? email;
  int? age;
  String? status;
  Timestamp? emailVerifyAt;
  List? additionalInformation;

  UserModel({
    /*required*/ this.uid,
    /*required*/ this.role,
    /*required*/ this.firstName,
    this.middleName,
    /*required*/ this.lastName,
    this.age,
    this.email,
    this.additionalInformation,
    this.emailVerifyAt,
    /*required*/ this.status,
    /*required*/ this.contactNumber,
    this.emeContactNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      firstName: json['first_name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      contactNumber: json['contact_number'] as String?,
      emeContactNumber: json['eme_contact_number'] as String?,
      emailVerifyAt: json['email_verify_at'] as Timestamp?,
      additionalInformation: json['additional_information'],
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'role': role,
      'age': age,
      'contact_number': contactNumber,
      'eme_contact_number': emeContactNumber,
      'additional_information': additionalInformation,
      'email_verify_at': emailVerifyAt,
      'status': status,
    };
  }
}
