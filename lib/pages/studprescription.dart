import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/studentViewmodel.dart';
import 'package:flutter_login_ui/services/studebtViewService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionViewPage extends StatefulWidget {
  @override
  _PrescriptionViewPageState createState() => _PrescriptionViewPageState();
}

class _PrescriptionViewPageState extends State<PrescriptionViewPage> {
  late Future<Student?> _studentFuture;
  final StudentService _studentService = StudentService();

  @override
  void initState() {
    super.initState();
    // Initialize _studentFuture in initState
    _initializeStudentFuture();
  }

  Future<void> _initializeStudentFuture() async {
    // Retrieve userId from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('_id');
    if (userId != null) {
      setState(() {
        _studentFuture = _studentService.getStudentDetails(userId);
      });
    } else {
      setState(() {
        _studentFuture = Future.value(null); // Initialize with null if userId is null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PRESCRIPTION DETAILS',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      // body: FutureBuilder<Student?>(
      //   future: _studentFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else {
      //       final student = snapshot.data;
      //       if (student != null && student.prescription != null) {
      //         // Display prescription details if available
      //         return Padding(
      //           padding: const EdgeInsets.all(16.0),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text('Prescription:'),
      //               Text('Doctor Notes: ${student.prescription!.doctorNotes}'),
      //               Text('Medicine: ${student.prescription!.medication.medicine}'),
      //               Text('Dosage: ${student.prescription!.medication.dosage}'),
      //               Text('Instructions: ${student.prescription!.medication.instructions}'),
      //             ],
      //           ),
      //         );
      //       } else {
      //         // Handle case where prescription details are not available
      //         return Center(child: Text('Prescription details not found.'));
      //       }
      //     }
      //   },
      // ),
    );
  }
}
