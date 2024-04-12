import 'dart:convert';
import 'package:flutter_login_ui/models/studentrequestmodel.dart';
import 'package:http/http.dart' as http;



class ViewRequestsService {
  static Future<List<Register>> fetchRequests() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3006/api/student/doctor-view-requests'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<Register> requests = responseData.map((data) => Register.fromJson(data)).toList();
        return requests;
      } else {
        throw Exception('Failed to fetch requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching requests: $e');
      throw e; // Re-throw the exception to be caught by the UI
    }
  }
}
