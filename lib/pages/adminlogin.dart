import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/models/userModel.dart';
import 'package:flutter_login_ui/pages/addstudentpage.dart';
import 'package:flutter_login_ui/pages/student_profile_page.dart';
import 'forgot_password_page.dart';
import 'doctor_profile_page.dart';
import 'widgets/header_widget.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  double _headerHeight = 250;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'MediConnect!',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Admin Login',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      child: Column(
                        children: [
                          Container(
                            child: TextField(
                              controller: _emailController,
                              decoration: ThemeHelper().textInputDecoration(
                                'User Name',
                                'Enter your user name',
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                'Password',
                                'Enter your password',
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                          //   alignment: Alignment.topRight,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => ForgotPasswordPage(),
                          //         ),
                          //       );
                          //     },
                          //     child: Text(
                          //       "Forgot your password?",
                          //       style: TextStyle(
                          //         color: Colors.lightBlue,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(
                              context,
                              '',
                              '',
                            ),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _signIn();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Hardcoded email and password for demo
    if (_emailController.text.isEmpty || !_isValidEmail(_emailController.text)) {
      showAlert(context: context, title: 'Invalid email format. Please enter a valid email.');
    }
    else if (_emailController.text == 'admin@gmail.com' && _passwordController.text == 'adm@123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddStudentPage(),
        ),
      );
    } else {
      showAlert(context: context, title: 'Invalid email or password. Please try again.');
    }
  }

  bool _isValidEmail(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }


  void showAlert({BuildContext? context, String? title}) {
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
