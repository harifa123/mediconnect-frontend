class Student {
  final String id;
  final String name;
  final String admissionNumber;
  final String email;

  Student({
    required this.id,
    required this.name,
    required this.admissionNumber,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['_id'],
        name: json['name'],
        admissionNumber: json['admissionNumber'],
        email: json['email']
    );
  }
}
