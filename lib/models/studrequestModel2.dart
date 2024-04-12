// To parse this JSON data, do
//
//     final studentRequest = studentRequestFromJson(jsonString);

import 'dart:convert';
List<StudentRequest> studentRequestFromJson(String str) => List<StudentRequest>.from(json.decode(str).map((x) => StudentRequest.fromJson(x)));
String studentRequestToJson(List<StudentRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentRequest {
  String userId;
  String name;
  String admissionNumber;
  String status;
  String email;
  String token;

  StudentRequest({
    required this.userId,
    required this.name,
    required this.admissionNumber,
    required this.status,
    required this.email,
    required this.token,
  });

  factory StudentRequest.fromJson(Map<String, dynamic> json) => StudentRequest(
    userId: json["userId"],
    name: json["name"],
    admissionNumber: json["admissionNumber"],
    status: json["status"],
    email: json["email"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "userId":userId,
    "name": name,
    "admissionNumber": admissionNumber,
    "status": status,
    "email": email,
    "token": token,
  };
}