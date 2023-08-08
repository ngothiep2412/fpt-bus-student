import 'dart:convert';

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  WalletModel({
    required this.id,
    required this.balance,
  });

  String id;
  int balance;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        id: json["id"] ?? "",
        balance: json["balance"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
      };
}
