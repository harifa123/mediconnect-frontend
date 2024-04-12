import 'dart:convert'; // Import dart:convert library

import 'package:flutter_login_ui/models/studentrequestmodel.dart';
import 'package:http/http.dart' as http;

class ViewService {
  Future<List<Register>> fetchRequest() async {
    final client = http.Client();
    try {
      final response = await client.post(
          Uri.parse('http://localhost:3006/api/student/doctor-view-requests'));
      print('Response body: ${response.body}'); // Add this line to log the response body
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => Register.fromJson(data)).toList();
      } else {
        throw Exception('Failed to fetch requests');
      }
    } finally {
      client.close(); // Close the client after use
    }
  }


}
