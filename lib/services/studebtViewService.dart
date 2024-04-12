import 'dart:convert';
import 'package:flutter_login_ui/models/studentViewmodel.dart';
import 'package:http/http.dart' as http;

class StudentService {
  static const String baseUrl = 'http://localhost:3006/api/student';

  Future<Student> getStudentDetails(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/viewprofile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        '_id': id,
      }),
    );

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load student details');
    }
  }
}
