import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentRequestService {
  Future<List<dynamic>> fetchStudentRequests({String? date}) async {
    try {
      print('Fetching student requests for date: $date'); // Add logging
      final response = await http.post(
        Uri.parse('http://localhost:3006/api/student/doctor-view-requests'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'date': date ?? '',
        }),
      );
      if (response.statusCode == 200) {
        print('HTTP request successful');
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
        throw Exception('Failed to load student requests');
      }
    } catch (error) {
      print('Error fetching student requests for date $date: $error'); // Add logging
      throw Exception('Failed to load student requests');
    }
  }

  Future<List<dynamic>> fetchAllStudentRequests() async {
    final response = await http.get(
        Uri.parse('http://localhost:3006/api/student/doctor-requests-all'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch requests');
    }
  }
}