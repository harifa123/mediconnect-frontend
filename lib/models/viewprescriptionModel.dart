class Prescription {
  final String userId;
  final String doctorNotes;
  final String medicine;
  final String dosage;
  final String instructions;

  Prescription({
    required this.userId,
    required this.doctorNotes,
    required this.medicine,
    required this.dosage,
    required this.instructions,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      userId: json['userId'],
      doctorNotes: json['doctorNotes'],
      medicine: json['medicine'],
      dosage: json['dosage'],
      instructions: json['instructions'],
    );
  }
}
