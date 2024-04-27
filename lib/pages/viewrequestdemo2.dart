import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/doctor_profile_page.dart';
import 'package:flutter_login_ui/pages/prescription.dart';
import 'package:flutter_login_ui/pages/ui_page_logins.dart';
import 'package:flutter_login_ui/services/student_request_service2.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_pdfview/flutter_pdfview.dart';

// Define StudentRequestsSearchDelegate here
class StudentRequestsSearchDelegate extends SearchDelegate<String> {
  final Function(String) searchByDisease;

  StudentRequestsSearchDelegate({required this.searchByDisease});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Perform the search and display results here
    return FutureBuilder<List<dynamic>>(
      future: searchByDisease(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Build UI to display search results
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];
              return ListTile(
                title: Text("Name :"+student['name']),
                subtitle: Text("AdmNo/EmpId :"+student['admissionNumber']),
                onTap: () {
                  // Handle tapping on search result
                  // You can navigate to another page or perform any action here
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Build UI to display search suggestions here
    return Container();
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    // Call searchByDisease function with query to perform search
    searchByDisease(query);
  }
}

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
      setState(() {
        _selectedDate = selectedDate;
      });
      if (_selectedDate != null) {
        _fetchStudentRequestsForDate(selectedDate);
      }
    }
  }

  Future<void> _downloadPdf() async {
    try {
      if (_selectedDate == null) {
        // Download all requests
        _downloadPdfForAll();
      } else {
        // Download requests for the selected date
        final url = Uri.parse('http://localhost:3006/api/student/download');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'date': _selectedDate}),
        );

        if (response.statusCode == 200) {
          final pdfBytes = response.bodyBytes;
          final blob = html.Blob([pdfBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'student_requests.pdf')
            ..click();
          html.Url.revokeObjectUrl(url);
        } else if (response.statusCode == 404) {
          // No data found for the specified date
          print('No file to download for the selected date.');
        } else {
          // Handle other errors
          print('Error downloading PDF: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle any errors
      print('Error downloading PDF: $e');
    }
  }


  Future<void> _downloadPdfForAll() async {
    final url = Uri.parse('http://localhost:3006/api/student/download');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final pdfBytes = response.bodyBytes;
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'student_requests.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Handle errors
      print('Error downloading PDF: ${response.statusCode}');
    }
  }

  Future<void> _resetDate() async {
    setState(() {
      _selectedDate = null;
      _studentRequests = _fetchAllStudentRequests();
    });
  }

  // Function to search by disease
  Future<List<dynamic>> _searchByDisease(String disease) async {
    try {
      final response = await StudentRequestService().searchStudentRequestsByDisease(disease);
      return response;
    } catch (e) {
      print("Error searching student requests by disease $disease: $e");
      return []; // Return an empty list in case of an error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Requests',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        // Make AppBar background transparent
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
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UiPage()),
                  (route) => false,
            );
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _resetDate(),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _downloadPdf(),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: StudentRequestsSearchDelegate(
                  searchByDisease: _searchByDisease,
                ),
              );
            },
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
                return Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: Text(
                      "Name: " + studentRequest['name'],
                      style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AdmNo/EmpId: ${studentRequest['admissionNumber']}',
                          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Token: ${studentRequest['token']}',
                          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Status: ${studentRequest['status']}',
                          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Container(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PrescriptionForm(userId: studentRequest['userId'])),
                          );
                        },
                      ),
                    ),
                  ),
                );
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
