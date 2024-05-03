class Station {
  String? name;
  String? stationCode;
  String? contact;

  Station({
    this.name,
    this.stationCode,
    this.contact,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json["name"] as String?,
      stationCode: json["station_code"] as String?,
      contact: json["contact"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "contact": contact,
      "station_code": stationCode,
    };
  }
}
