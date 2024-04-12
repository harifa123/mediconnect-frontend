import 'dart:convert';
import 'package:http/http.dart' as http;

class SetPasswordApiService {
  static const String baseUrl = 'http://localhost:3006/api/student';

  static Future<String> setPassword(String userId, String password) async {
    final String apiUrl = '$baseUrl/set-password';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        '_id': userId,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return 'Permanent password set successfully. You can now login with your permanent password.';
    } else if (response.statusCode == 400) {
      throw Exception('Student not found. Please check your email.');
    } else if (response.statusCode == 401) {
      throw Exception('Temporary password must be used before setting permanent password.');
    } else {
      throw Exception('Server error');
    }
  }
}
