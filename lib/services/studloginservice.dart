import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginApiService {
  static const String baseUrl = 'http://localhost:3006/api/student'; // Update with your API base URL

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final String apiUrl = '$baseUrl/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email. Please try again.');
    }
    else if (response.statusCode == 402) {
      throw Exception('Invalid password. Please try again.');
    }else {
      throw Exception('Server error');
    }
  }
}
