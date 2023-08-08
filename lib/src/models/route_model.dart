// TEST

import 'package:fbus_app/src/models/station_model.dart';

class RouteModel {
  RouteModel({
    required this.id,
    required this.routeName,
    required this.departure,
    required this.departureCoordinates,
    required this.destination,
    required this.destinationCoordinates,
    required this.status,
    required this.stations,
  });

  String id;
  String routeName;
  String departure;
  List<CoordinateModel> departureCoordinates;
  String destination;
  List<CoordinateModel> destinationCoordinates;
  bool status;
  List<Station> stations;

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        id: json["id"],
        routeName: json["route_name"],
        departure: json["departure"],
        departureCoordinates: List<CoordinateModel>.from(
            json["departure_coordinates"]
                .map((x) => CoordinateModel.fromJson(x))),
        destination: json["destination"],
        destinationCoordinates: List<CoordinateModel>.from(
            json["destination_coordinates"]
                .map((x) => CoordinateModel.fromJson(x))),
        status: json["status"],
        stations: List<Station>.from(
            json["stations"].map((x) => Station.fromJson(x))),
      );

  static List<RouteModel> fromJsonList(List list) {
    return list.map((item) => RouteModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.departure}';
  }

  ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return this.createdAt?.toString().contains(filter) ?? false;
  // }

  ///custom comparing function to check if two users are equal
  bool isEqual(RouteModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => routeName;
}

class CoordinateModel {
  CoordinateModel({
    required this.longitude,
    required this.latitude,
  });

  String longitude;
  String latitude;
  factory CoordinateModel.fromJson(Map<String, dynamic> json) =>
      CoordinateModel(
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}
