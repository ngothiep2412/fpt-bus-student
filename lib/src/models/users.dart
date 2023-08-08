import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? fullname;
  String? email;
  String? phoneNumber;
  String? studentId;
  String? profileImg;
  String? roleName;
  bool? status;

  UserModel({
    this.id,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.studentId,
    this.profileImg,
    this.roleName,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        studentId: json["student_id"],
        profileImg: json["profile_img"],
        roleName: json["role_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "phone_number": phoneNumber,
        "student_id": studentId,
        "profile_img": profileImg,
        "role_name": roleName,
        "status": status,
      };
}
