import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/prescription.dart';
import 'package:flutter_login_ui/services/student_request_service2.dart';

class StudentRequestsScreen extends StatefulWidget {
  @override
  _StudentRequestsScreenState createState() => _StudentRequestsScreenState();
}

class _StudentRequestsScreenState extends State<StudentRequestsScreen> {
  late Future<List<dynamic>> _studentRequests = _fetchAllStudentRequests();
  String? _selectedDate;

  Future<List<dynamic>> _fetchAllStudentRequests() async {
    try {
      final response = await StudentRequestService().fetchAllStudentRequests();
      return response ?? [];
    } catch (e) {
      print("Error fetching all student requests: $e");
      return [];
    }
  }

  Future<void> _fetchStudentRequestsForDate(String? date) async {
    if (date == null) return;
    try {
      final response = await StudentRequestService().fetchStudentRequests(date: date);
      setState(() {
        _studentRequests = Future.value(response);
      });
    } catch (e) {
      print("Error fetching student requests for date $date: $e");
      setState(() {
        _studentRequests = Future.value([]);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final selectedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      print('Selected date: $_selectedDate'); // Add logging
      setState(() {
        _selectedDate = selectedDate;
      });
      if (_selectedDate != null) { // Check if _selectedDate is not null
        _fetchStudentRequestsForDate(selectedDate);
      }
    }
  }



  Future<void> _resetDate() async {
    setState(() {
      _selectedDate = null;
      _studentRequests = _fetchAllStudentRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Requests',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.6),
              Colors.indigo.withOpacity(0.6),
              Colors.blueAccent.withOpacity(0.6),

            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _resetDate(),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _studentRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('No data found for the selected date.'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final studentRequest = snapshot.data![index];
                // String buttonLabel = 'Approve'; // Default label
                // Color buttonColor = Colors.blue;
                // if (studentRequest[status] == 'Approved') {
                //   buttonLabel = 'add prescription';
                //   buttonColor = Colors.green;
                // } else if (studentRequest.status == 'add prescription') {
                //   buttonLabel = 'Done';
                //   buttonColor = Colors.orange;
                // }
                SizedBox(height: 40,);
                return Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                child:  ListTile(
                  title: Text("Name: " + studentRequest['name'],style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admission Number: ${studentRequest['admissionNumber']}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                      Text('Token: ${studentRequest['token']}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                      Text('Status: ${studentRequest['status']}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  trailing: Container(
                    // decoration: ThemeHelper().buttonBoxDecoration(context, '', ''),
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
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          studentRequest['status'] == 'Done' ? 'Done' : 'Add prescription',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () async {
    // if (studentRequest['status'] == 'add prescription') {
    //   // Change the status to 'Done'
    //   setState(() {
    //     studentRequest['status'] = 'Done';
    //   });
    // }
                          // Navigate to prescription form with userId parameter
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PrescriptionForm(userId: studentRequest['userId'])),
                          );
                        }
                    ),
                  ),
                ),);

              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentRequestsScreen(),
  ));
}

