// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:connectivity/connectivity.dart'; // Import Connectivity package
// import '../models/studentrequestmodel.dart';
// import '../services/viewrequestsService.dart';
//
// class ViewRequestsPage extends StatefulWidget {
//   @override
//   _ViewRequestsPageState createState() => _ViewRequestsPageState();
// }
//
// class _ViewRequestsPageState extends State<ViewRequestsPage> {
//   late Future<List<StudentRequest>> _futureRequests;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRequests();
//   }
//
//   Future<void> _loadRequests() async {
//     try {
//       setState(() {
//         _futureRequests = ViewRequestsService.fetchRequests();
//       });
//     } catch (e) {
//       // Handle the error
//       setState(() {
//         _futureRequests = Future.error(e.toString());
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('View Requests'),
//       ),
//       body: FutureBuilder<List<StudentRequest>>(
//         future: _futureRequests,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error fetching requests: ${snapshot.error}'));
//           } else {
//             final requests = snapshot.data!;
//             return ListView.builder(
//               itemCount: requests.length,
//               itemBuilder: (context, index) {
//                 final request = requests[index];
//                 return Card(
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(request.name),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Admission Number: ${request.admissionNumber}'),
//                         Text('Disease: ${request.disease}'),
//                       ],
//                     ),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         if (request.status == 'add prescription') {
//                           // Show prescription details dialog
//                           _showPrescriptionDialog(request.id);
//                         } else {
//                           _updateRequestStatus(request);
//                         }
//                       },
//                       child: Text(_getButtonLabel(request.status)),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   String _getButtonLabel(String status) {
//     if (status == 'pending') {
//       return 'Pending';
//     } else if (status == 'approved') {
//       return 'Approved';
//     } else {
//       return 'Add Prescription';
//     }
//   }
//
//   void _updateRequestStatus(StudentRequest request) async {
//     try {
//       final response = await http.put(
//         Uri.parse('http://localhost:3001/api/student/approve-request'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{'_id': request.id}),
//       );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Request status updated successfully')),
//         );
//         // Update the request object with the new status
//         setState(() {
//           if (request.status == 'pending') {
//             request = StudentRequest(
//               id: request.id,
//               name: request.name,
//               admissionNumber: request.admissionNumber,
//               disease: request.disease,
//               status: 'approved',
//             );
//           } else if (request.status == 'approved') {
//             request = StudentRequest(
//               id: request.id,
//               name: request.name,
//               admissionNumber: request.admissionNumber,
//               disease: request.disease,
//               status: 'add prescription',
//             );
//           }
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update request status')),
//         );
//       }
//     } catch (error) {
//       print('Error updating request status: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating request status')),
//       );
//     }
//   }
//
//   Future<void> _showPrescriptionDialog(String studentId) async {
//     TextEditingController doctorNotesController = TextEditingController();
//     TextEditingController medicineController = TextEditingController();
//     TextEditingController dosageController = TextEditingController();
//     TextEditingController instructionsController = TextEditingController();
//
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Prescription'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 TextField(
//                   controller: doctorNotesController,
//                   decoration: InputDecoration(labelText: 'Doctor Notes'),
//                 ),
//                 TextField(
//                   controller: medicineController,
//                   decoration: InputDecoration(labelText: 'Medicine'),
//                 ),
//                 TextField(
//                   controller: dosageController,
//                   decoration: InputDecoration(labelText: 'Dosage'),
//                 ),
//                 TextField(
//                   controller: instructionsController,
//                   decoration: InputDecoration(labelText: 'Instructions'),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Submit'),
//               onPressed: () {
//                 _submitPrescription(
//                   studentId,
//                   doctorNotesController.text,
//                   {
//                     'medicine': medicineController.text,
//                     'dosage': dosageController.text,
//                     'instructions': instructionsController.text,
//                   },
//                 );
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _submitPrescription(String studentId, String doctorNotes,
//       Map<String, String> medication) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3001/api/student/submit-prescription'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           '_id': studentId,
//           'doctorNotes': doctorNotes,
//           'medication': medication,
//         }),
//       ); // Add semicolon here
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Prescription submitted successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to submit prescription')),
//         );
//       }
//     } catch (error) {
//       print('Error submitting prescription: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error submitting prescription')),
//       );
//     }
//   }
//
// }
