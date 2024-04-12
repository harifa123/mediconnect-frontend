import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/models/studentrequestmodel.dart';
import 'package:flutter_login_ui/services/updateStatusService.dart';
import 'package:flutter_login_ui/services/viewServicedemo.dart';
import 'package:flutter_login_ui/pages/prescription.dart';

class ViewRequestPage extends StatefulWidget {
  @override
  _ViewRequestPageState createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<ViewRequestPage> {
  late Future<List<Register>> data;

  @override
  void initState() {
    super.initState();
    data = ViewService().fetchRequest();
  }

  Future<void> _updateStatus(String userId) async {
    try {
      await UpdateStatusService.approveRequest(userId);
      // Refresh the data after updating status
      setState(() {
        data = ViewService().fetchRequest();
      });
    } catch (e) {
      print('Error updating status: $e'); // Print error to console
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STUDENT REQUESTS',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      ),
      body: FutureBuilder<List<Register>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}'); // Print error to console
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final request = snapshot.data![index];
                String buttonLabel = 'Approve'; // Default label
                Color buttonColor = Colors.blue;
                if (request.status == 'Approved') {
                  buttonLabel = 'add prescription';
                  buttonColor = Colors.green;
                } else if (request.status == 'add prescription') {
                  buttonLabel = 'Done';
                  buttonColor = Colors.orange;
                }
                // Inside the ListView.builder itemBuilder method
                SizedBox(height: 40,);
                return Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: Text('${request.name ?? "N/A"}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student Name: ${request.name ?? "N/A"}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),), // Handle null name
                        Text('Admission Number: ${request.admissionNumber ?? "N/A"}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),), // Handle null admission number
                        Text('Disease: ${request.disease ?? "N/A"}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),), // Handle null disease
                      ],
                    ),
                    trailing: Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context, '', ''),
                      child: ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            buttonLabel ?? "N/A".toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (request.status == 'Approved') {
                            // Navigate to prescription form with userId parameter
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PrescriptionForm(userId: request.userId)),
                            );
                          } else {
                            _updateStatus(request.userId);
                          }
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
