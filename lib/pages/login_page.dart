import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/forgot_password_page.dart';
import 'package:flutter_login_ui/pages/registration_page.dart';
import 'package:flutter_login_ui/pages/student_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

import '../services/studloginservice.dart'; // Import the login API service

class StudLoginPage extends StatefulWidget {
  const StudLoginPage({Key? key}) : super(key: key);

  @override
  _StudLoginPageState createState() => _StudLoginPageState();
}

class _StudLoginPageState extends State<StudLoginPage> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();
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
                      'User Login',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              controller: _emailController,
                              decoration:
                              ThemeHelper().textInputDecoration('Email Id', 'Enter your email id'),
                              validator: (val) {
                                if (val!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration:
                              ThemeHelper().textInputDecoration('Password', 'Enter your password'),
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
                          //         MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
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
                            decoration: ThemeHelper().buttonBoxDecoration(context, '', ''),
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
                              onPressed: () async {
                                final email = _emailController.text;
                                final password = _passwordController.text;
                                try {
                                  final response = await LoginApiService.loginUser(email, password);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(response['message']),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Set _id to shared preferences
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('_id', response['_id']);
                                  // Navigate to the bottom navigation page
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => StudentHomePage()),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(text: "Don\'t have an account? "),
                                TextSpan(
                                  text: 'signup',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                                      );
                                    },
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ]),
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
}
