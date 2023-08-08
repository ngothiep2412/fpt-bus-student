import 'dart:convert';

List<TripModel> tripModelFromJson(String str) =>
    List<TripModel>.from(json.decode(str).map((x) => TripModel.fromJson(x)));

String tripModelToJson(List<TripModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripModel {
  TripModel({
    required this.id,
    required this.routeId,
    required this.busId,
    required this.departureDate,
    required this.departureTime,
    required this.ticketQuantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.statusName,
    required this.departure,
    required this.destination,
    required this.licensePlate,
    required this.driverName,
  });

  String id;
  String routeId;
  String busId;
  DateTime departureDate;
  String departureTime;
  int ticketQuantity;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String statusName;
  String departure;
  String destination;
  String licensePlate;
  String driverName;

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        id: json["id"],
        routeId: json["route_id"],
        busId: json["bus_id"],
        departureDate: DateTime.parse(json["departure_date"]),
        departureTime: json["departure_time"],
        ticketQuantity: json["ticket_quantity"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        statusName: json["status_name"],
        departure: json["departure"],
        destination: json["destination"],
        licensePlate: json["license_plate"],
        driverName: json["driver_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "route_id": routeId,
        "bus_id": busId,
        "departure_date":
            "${departureDate.year.toString().padLeft(4, '0')}-${departureDate.month.toString().padLeft(2, '0')}-${departureDate.day.toString().padLeft(2, '0')}",
        "departure_time": departureTime,
        "ticket_quantity": ticketQuantity,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "status_name": statusName,
        "departure": departure,
        "destination": destination,
        "license_plate": licensePlate,
        "driver_name": driverName,
      };
}
