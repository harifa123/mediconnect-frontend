class Student {
  final String name;
  final String email;
  final String admissionNumber;

  Student({
    required this.name,
    required this.email,
    required this.admissionNumber,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      email: json['email'],
      admissionNumber: json['admissionNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'admissionNumber': admissionNumber,
  };
}
