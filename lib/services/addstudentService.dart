import 'dart:convert';
import 'package:flutter_login_ui/models/addstudentModel.dart';
import 'package:http/http.dart' as http;


class StudentService {
  static Future<String> addStudent(Student student) async {
    final response = await http.post(
      Uri.parse('http://localhost:3006/api/admin/addStudent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(student.toJson()),
    );

    if (response.statusCode == 200) {
      return 'User added successfully';
    } else if (response.statusCode == 400) {
      return 'User already registered';
    } else {
      throw Exception('Failed to add User');
    }
  }
}
