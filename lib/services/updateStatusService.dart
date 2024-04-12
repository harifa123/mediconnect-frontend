// update_status_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class UpdateStatusService {
  static Future<void> approveRequest(String userId) async {
    final response = await http.put(
      Uri.parse('http://localhost:3006/api/student/approve-request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      print('Request status updated successfully.');
    } else {
      throw Exception('Failed to update request status');
    }
  }
}
