// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

List<Register> registerFromJson(String str) => List<Register>.from(json.decode(str).map((x) => Register.fromJson(x)));

String registerToJson(List<Register> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Register {
  String userId;
  String email;
  String admissionNumber;

  Register({
    required this.userId,
    required this.email,
    required this.admissionNumber,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
    userId: json["userId"],
    email: json["email"],
    admissionNumber: json["admissionNumber"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "email": email,
    "admissionNumber": admissionNumber,
  };
}
