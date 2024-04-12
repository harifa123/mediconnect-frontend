import 'dart:convert';

List<Register> registerFromJson(String str) => List<Register>.from(json.decode(str).map((x) => Register.fromJson(x)));

String registerToJson(List<Register> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Register {
  String userId;
  String name;
  String admissionNumber;
  String disease;
  String status;


  Register({
    required this.userId,
    required this.name,
    required this.admissionNumber,
    required this.disease,
    required this.status,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
    userId: json["userId"],
    name: json["name"],
    admissionNumber: json["admissionNumber"],
    disease: json["disease"],
    status: json["status"],
  );



  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "admissionNumber": admissionNumber,
    "disease": disease,
    "status": status
  };
}
