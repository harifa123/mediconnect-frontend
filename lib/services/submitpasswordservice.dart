import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestApiService {
  static const String baseUrl = 'http://localhost:3006/api/student';

  static Future<String> submitPassword(String userId, String password) async {
    final String apiUrl = '$baseUrl/register';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        '_id': userId,
        'temporaryPassword': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return 'Registration successful. You can now set the permanent password.';
    } else if (response.statusCode == 400) {
      throw Exception('Invalid temporary password. Please try again.');
    } else {
      throw Exception('Server error');
    }
  }
}
