import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    required this.id,
    this.ticketId,
    required this.description,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  dynamic ticketId;
  String description;
  String walletId;
  int amount;
  String type;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        ticketId: json["ticket_id"],
        description: json["description"],
        walletId: json["wallet_id"],
        amount: json["amount"],
        type: json["type"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_id": ticketId,
        "description": description,
        "wallet_id": walletId,
        "amount": amount,
        "type": type,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
