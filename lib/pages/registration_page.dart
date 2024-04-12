import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/widgets/header_widget.dart';
import 'package:flutter_login_ui/pages/TemporaryPasswordPage.dart';
import '../services/studentService.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController admissionNumberController = TextEditingController();
  bool checkboxValue = false;

  String? userId; // Define userId variable as nullable

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final admissionNumber = admissionNumberController.text;

      try {
        final response = await ApiService.registerRequest(email, admissionNumber);
        final String? successMessage = response['successMessage']; // Extract success message
        final String? userId = response['userId']; // Extract userId

        if (successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ));
        }

        if (userId != null) {
          setState(() {
            this.userId = userId; // Set userId if response contains it
          });
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TemporaryPasswordPage(userId: userId)), // Pass userId to TemporaryPasswordPage
                (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, CircleAvatar(backgroundImage: AssetImage('images/logo_letter.png'), radius: 20)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              // height: _headerHeight,
                              // width: 300,
                              child: HeaderWidget(_headerHeight, true, CircleAvatar(
                                backgroundImage: AssetImage('images/logo_letter_box_med.png'),
                                radius: 60,
                                backgroundColor: Colors.white,
                              )),
                            ),
              Container(
                margin: EdgeInsets.fromLTRB(25, _headerHeight - 50, 25, 10), // Adjust margin.top based on logo height
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "SignUp!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigoAccent), // Customize text style as needed
                    ),


                          ],
                        ),),]),
                        SizedBox(height: 50),
                        Container(
                          child: TextFormField(

                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShadow(),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            controller: admissionNumberController,
                            decoration: ThemeHelper().textInputDecoration('Admission Number', 'Enter your admission number'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Enter your admission number';
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShadow(),
                        ),
                        SizedBox(height: 20),
                        // FormField<bool>(
                        //   builder: (state) {
                        //     return Column(
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             // Checkbox(
                        //             //   value: checkboxValue,
                        //             //   onChanged: (value) {
                        //             //     setState(() {
                        //             //       checkboxValue = value!;
                        //             //       state.didChange(value);
                        //             //     });
                        //             //   },
                        //             // ),
                        //             // Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey)),
                        //           ],
                        //         ),
                        //         Container(
                        //           alignment: Alignment.centerLeft,
                        //           child: Text(
                        //             state.errorText ?? '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12),
                        //           ),
                        //         )
                        //       ],
                        //     );
                        //   },
                        //   validator: (value) {
                        //     if (!checkboxValue) {
                        //       return 'You need to accept terms and conditions';
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        // SizedBox(height: 20),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context, '', ''),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            onPressed: _register,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Get otp".toUpperCase(),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
