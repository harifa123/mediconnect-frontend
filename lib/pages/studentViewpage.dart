import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/studentViewmodel.dart';
import 'package:flutter_login_ui/services/studebtViewService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDetailsPage extends StatefulWidget {
  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  Student? _student;
  bool _isLoading = true; // Initialize isLoading to true

  @override
  void initState() {
    super.initState();
    _fetchStudentDetails();
  }

  Future<void> _fetchStudentDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String studentId = prefs.getString('_id') ?? '';
      Student student = await StudentService().getStudentDetails(studentId);
      setState(() {
        _student = student;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error here
      print('Error fetching student details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('MY INFO', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
          backgroundColor: Colors.transparent,
          // Make AppBar background transparent
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildStudentDetails(),
    );
  }

  Widget _buildStudentDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.withOpacity(0.6), Colors.indigo.withOpacity(0.6), Colors.indigoAccent.withOpacity(0.6)],
            // Set your gradient colors
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(
              10.0), // Optional: Set border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(55.0),
          child: _student != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${_student!.name ?? 'N/A'}', style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),),
              Text('Admission Number: ${_student!.admissionNumber ?? 'N/A'}',
                style: TextStyle(fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),
              Text('Email: ${_student!.email ?? 'N/A'}', style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),),
            ],
          )
              : Text('Failed to load student details'),
        ),
      ),
    );
  }
}
