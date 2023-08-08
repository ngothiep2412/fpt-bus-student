class Station {
  Station({
    required this.id,
    required this.stationName,
    required this.longitude,
    required this.latitude,
    this.status,
    this.createdAt,
    this.updadtedAt,
  });

  String id;
  String stationName;
  String longitude;
  String latitude;
  int? status;
  DateTime? createdAt;
  DateTime? updadtedAt;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json["id"],
        stationName: json["station_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updadtedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "station_name": stationName,
        "longitude": longitude,
        "latitude": latitude,
        "status": status,
        "createdAt": createdAt!.toIso8601String(),
        "updadtedAt": updadtedAt!.toIso8601String(),
      };
}
