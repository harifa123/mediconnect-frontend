import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/core/services/apiService.dart';
import 'package:flutter_login_ui/models/userModel.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';


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
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'DocQuik!',
                        style: TextStyle(
                            fontSize: 60,
                            color: Colors.indigoAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Student Login',
                        style: TextStyle(color: Colors.grey,
                          fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextField(
                                  controller: _emailController,
                                  decoration: ThemeHelper().textInputDecoration('User Name', 'Enter your user name')),
                                //decoration: ThemeHelper().inputBoxDecorationShadow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),),
                                //decoration: ThemeHelper().inputBoxDecorationShadow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration:
                                ThemeHelper().buttonBoxDecoration(context,'',''),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await ApiService()
                                        .loginUser(User(
                                        email: _emailController.text,
                                        password: _passwordController.text))
                                        .then((data) {
                                      if (data.access_token!.isNotEmpty) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage()));
                                      } else {
                                        showAlert(
                                            context: context, title: data.msg);
                                      }
                                      ;
                                    });

                                    //After successful login we will redirect to profile page. Let's create profile page now
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "Don\'t have an account? "),
                                  TextSpan(
                                    text: 'signup',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
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
