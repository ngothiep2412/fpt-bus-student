// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.dataTitle,
    this.dataBody,
    required this.sentTime,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String title;
  String body;
  dynamic dataTitle;
  dynamic dataBody;
  DateTime sentTime;
  DateTime createdAt;
  DateTime updatedAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        dataTitle: json["dataTitle"],
        dataBody: json["dataBody"],
        sentTime: DateTime.parse(json["sentTime"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "dataTitle": dataTitle,
        "dataBody": dataBody,
        "sentTime": sentTime.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
