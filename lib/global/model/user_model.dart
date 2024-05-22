import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  // String? firstName;
  // String? middleName;
  // String? lastName;
  String? fullName;
  String? birthday;
  String? address;
  String? role;
  String profile;
  String? contactNumber;
  String? emeContactNumber;
  String? emeContactName;
  String? allergies;
  String? bloodType;
  String? email;
  String? department;
  String? gender;
  int? age;
  String? status;
  String? fcmToken;
  Timestamp? emailVerifyAt;
  Timestamp createdAt = Timestamp.now();
  List? additionalInformation;

  UserModel({
    this.uid,
    this.role,
    // this.firstName,
    // this.middleName,
    // this.lastName,
    this.age,
    this.email,
    this.additionalInformation,
    this.emailVerifyAt,
    this.status,
    this.contactNumber,
    this.department,
    this.emeContactNumber,
    this.emeContactName,
    this.fcmToken,
    this.address,
    this.allergies,
    this.birthday,
    this.bloodType,
    this.fullName,
    this.profile =
        "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/profile%2Fperson.png?alt=media&token=947f5244-0157-43ab-8c3e-349ae9699415",
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      // firstName: json['first_name'] as String?,
      // middleName: json['middle_name'] as String?,
      // lastName: json['last_name'] as String?,
      profile: json['profile'] as String,
      fullName: json['full_name'] as String?,
      bloodType: json['blood_type'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
      allergies: json['allergies'] as String?,
      address: json['address'] as String?,
      age: json['age'] as int?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      contactNumber: json['contact_number'] as String?,
      department: json['department'] as String?,
      fcmToken: json["fcm_token"] as String?,
      emeContactNumber: json['eme_contact_number'] as String?,
      emeContactName: json['eme_contact_name'] as String?,
      emailVerifyAt: json['email_verify_at'] as Timestamp?,
      additionalInformation: json['additional_information'],
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'uid': uid,
      // 'first_name': firstName,
      // 'middle_name': middleName,
      // 'last_name': lastName,
      'email': email,
      'role': role,
      'age': age,
      'contact_number': contactNumber,
      'department': department,
      'eme_contact_number': emeContactNumber,
      'eme_contact_name': emeContactName,
      'additional_information': additionalInformation,
      'email_verify_at': emailVerifyAt,
      'status': status,
      'fcm_token': fcmToken,
      "address": address,
      "allergies": allergies,
      "birthday": birthday,
      "blood_type": bloodType,
      "full_name": fullName,
      "gender": gender,
      "profile": profile,
    };
  }
}
