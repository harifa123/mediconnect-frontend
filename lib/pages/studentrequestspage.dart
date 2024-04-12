import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/studentrequestService.dart';

class StudentRequestPage extends StatefulWidget {
  @override
  _StudentRequestPageState createState() => _StudentRequestPageState();
}

class _StudentRequestPageState extends State<StudentRequestPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _admissionNumberController;
  late TextEditingController _diseaseController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _admissionNumberController = TextEditingController();
    _diseaseController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BOOK APPOINTMENT',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      body: SingleChildScrollView(

        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: TextFormField(
                  controller: _nameController,
                  decoration:ThemeHelper().textInputDecoration('Name', 'Enter your name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _admissionNumberController,
                decoration:ThemeHelper().textInputDecoration('Admission Number', 'Enter your admission number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your admission number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _diseaseController,
                decoration:ThemeHelper().textInputDecoration('Disease', 'Enter disease'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your disease';
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

                child: ElevatedButton(
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
                    if (_formKey.currentState!.validate()) {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      final String? userId = prefs.getString('_id');

                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User not logged in')),
                        );
                        return;
                      }

                      try {
                        final message = await StudentRequestService.submitStudentRequest(
                          userId: userId,
                          name: _nameController.text,
                          admissionNumber: _admissionNumberController.text,
                          disease: _diseaseController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message),backgroundColor: Colors.green,),

                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to submit student request'),backgroundColor: Colors.red,),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _admissionNumberController.dispose();
    _diseaseController.dispose();
    super.dispose();
  }
}
