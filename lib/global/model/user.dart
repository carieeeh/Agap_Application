class User {
  int id;
  String? firstName;
  String? middleName;
  String? lastName;
  int? age;
  List? additionalInformation;

  User({
    required this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.age,
    this.additionalInformation,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
    };
  }
}
