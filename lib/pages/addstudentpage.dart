import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/models/addstudentModel.dart';
import 'package:flutter_login_ui/pages/ui_page_logins.dart';
import 'package:flutter_login_ui/services/addstudentService.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _admissionNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _admissionNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:ThemeHelper().textInputDecoration('Name', 'Enter Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
                decoration:ThemeHelper().textInputDecoration('Email', 'Enter Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter the valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _admissionNumberController,
                decoration:ThemeHelper().textInputDecoration('Admission Number', 'Enter Admission Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the admission number';
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
                  if (_formKey.currentState!.validate()) {
                    Student student = Student(
                      name: _nameController.text,
                      email: _emailController.text,
                      admissionNumber: _admissionNumberController.text,
                    );
                    try {
                      String message = await StudentService.addStudent(student);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message), backgroundColor: Colors.green),
                      );
                    } catch (e) {
                      String message = await StudentService.addStudent(student);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                // child: Text('Add Student'),
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
    _emailController.dispose();
    _admissionNumberController.dispose();
    super.dispose();
  }
}
