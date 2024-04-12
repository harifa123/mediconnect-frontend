// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class PrescriptionService {
//   static Future<String> submitPrescription(
//       {required String userId,
//         required String doctorNotes,
//         required Map<String, String> medication}) async {
//     final url = Uri.parse('http://localhost:3006/api/student/submit-prescription');
//     final headers = {'Content-Type': 'application/json'};
//     final body = json.encode({
//       'userId': userId,
//       'doctorNotes': doctorNotes,
//       'medication': medication,
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       return 'Prescription submitted successfully.';
//     } else {
//       throw Exception('Failed to submit prescription: ${response.body}');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrescriptionService {
  static Future<String?> submitPrescription({
    required String userId,
    required String doctorNotes,
    required String medicine,
    required String dosage,
    required String instructions,
    required BuildContext context, // Include the context parameter
  }) async {
    final url = Uri.parse('http://localhost:3006/api/student/submit-prescription');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': userId,
      'doctorNotes': doctorNotes,
      'medicine': medicine,
      'dosage': dosage,
      'instructions': instructions,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Prescription submitted successfully.'),
          duration: Duration(seconds: 2),backgroundColor: Colors.green,
        ));
        // Return null to indicate successful submission
        return null;
      } else {
        throw Exception('Failed to submit prescription: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error submitting prescription: $error'),
        duration: Duration(seconds: 4),
      ));
      // Return an error message to indicate the failure
      return 'Error submitting prescription: $error';
    }
  }
}