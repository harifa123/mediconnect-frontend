import 'package:flutter_login_ui/models/viewprescriptionModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PrescriptionService {
  static const String baseUrl = 'http://localhost:3006/api/student';

  static Future<List<Prescription>> getPrescriptions(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/viewprescription'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Prescription.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }
}

