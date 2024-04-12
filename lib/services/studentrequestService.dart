import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentRequestService {
  static const String baseUrl = 'http://localhost:3006/api/student';

  static Future<String> submitStudentRequest({
    required String userId,
    required String name,
    required String admissionNumber,
    required String disease,
  }) async {
    final url = Uri.parse('$baseUrl/student-request');

    final request = {
      'userId': userId,
      'name': name,
      'admissionNumber': admissionNumber,
      'disease': disease,
    };

    final response = await http.post(
      url,
      body: json.encode(request),
      headers: {'Content-Type': 'application/json'},
    );
    print("submit request" +response.statusCode.toString());

    if (response.statusCode == 201) {
      return 'Student request submitted successfully.';
    } else {
      throw Exception('Failed to submit student request');
    }
  }
}
