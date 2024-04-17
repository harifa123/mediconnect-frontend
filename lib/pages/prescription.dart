import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/viewrequestdemo.dart';
import 'package:flutter_login_ui/pages/viewrequestdemo2.dart';
import '../services/submitprescriptionService.dart';

class PrescriptionForm extends StatefulWidget {
  final String userId;
  PrescriptionForm({required this.userId});
  @override
  _PrescriptionFormState createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<PrescriptionForm> {
  final TextEditingController doctorNotesController = TextEditingController();
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PRESCRIPTION FORM',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                TextFormField(
                  controller: doctorNotesController,
                  decoration:ThemeHelper().textInputDecoration('Doctor Notes', 'Doctor Notes'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Doctor Notes';
                    }
                    return null;
                  },
                ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: medicineController,
              decoration:ThemeHelper().textInputDecoration('Medicine', 'Enter Medicine'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Medicine';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: dosageController,
              decoration:ThemeHelper().textInputDecoration('Dosage', 'Enter Dosage'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Dosage';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: instructionsController,
              decoration:ThemeHelper().textInputDecoration('Instructions', 'Enter Instructions'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Instructions';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
        Container(
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
           child:  ElevatedButton(
              style: ThemeHelper().buttonStyle(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Text(
                  'submit'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () async {
                final String doctorNotes = doctorNotesController.text;
                final String medicine = medicineController.text;
                final String dosage = dosageController.text;
                final String instructions = instructionsController.text;

                final String? message = await PrescriptionService.submitPrescription(
                  userId: widget.userId,
                  doctorNotes: doctorNotes,
                  medicine: medicine,
                  dosage: dosage,
                  instructions: instructions,
                  context: context, // Pass the context
                );

                if (message == null) {
                  // Navigate back to the previous page if submission was successful
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => StudentRequestsScreen()),
                  );
                }
              },
              // child: Text('Submit Prescription'),
            ),
        ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    doctorNotesController.dispose();
    medicineController.dispose();
    dosageController.dispose();
    instructionsController.dispose();
    super.dispose();
  }
}
