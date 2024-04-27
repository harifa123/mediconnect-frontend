import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  Future<void> applyForLeave() async {
    String date = dateController.text;
    String reason = reasonController.text;

    // Validate date format
    RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(date)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Date Format"),
            content: Text("Please enter a date in YYYY-MM-DD format."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3006/api/student/apply-for-leave'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'date': date,
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Leave applied successfully."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to apply for leave');
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Internal Server Error"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APPLY FOR LEAVE',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.6),
                  Colors.indigo.withOpacity(0.6),
                  Colors.blueAccent.withOpacity(0.6),
                  // Example opacity value (0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          centerTitle: true
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: dateController,
              decoration:ThemeHelper().textInputDecoration('Date (YYYY-MM-DD)', 'Enter Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: reasonController,
              decoration:ThemeHelper().textInputDecoration('Reason', 'Enter Reason'),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.6),
                    Colors.indigo.withOpacity(0.6),
                    Colors.blueAccent.withOpacity(0.6),
                    // Example opacity value (0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),

              child: ElevatedButton(
                style: ThemeHelper().buttonStyle(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Text(
                    'Apply for Leave'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: applyForLeave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Leave Application',
    home: LeaveApplicationForm(),
  ));
}
