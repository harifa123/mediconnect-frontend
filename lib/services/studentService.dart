import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3006/api/student';

  static Future<Map<String, dynamic>> registerRequest(String email, String admissionNumber) async {
    final String apiUrl = '$baseUrl/register-request';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'email': email,
        'admissionNumber': admissionNumber,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print("response status code : ${response.statusCode}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String? userId = responseData['userId'];
      if (userId != null) {
        return {'successMessage': 'Temporary password sent successfully. Check your email.', 'userId': userId};
      } else {
        throw Exception("UserId not found in response");
      }
    } else if (response.statusCode == 400) {
      throw Exception('Student not found. Please check your email and admission number.');
    } else if (response.statusCode == 401) {
      throw Exception('You have already registered.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception('Server error');
    }
  }
}
