import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/ui_page_logins.dart';
import 'package:flutter_login_ui/pages/widgets/header_widget.dart';

import '../services/permanentpasService.dart';
import 'login_page.dart'; // Import the LoginPage

class SetPermanentPasswordPage extends StatefulWidget {
  final String userId;

  SetPermanentPasswordPage({required this.userId});

  @override
  _SetPermanentPasswordPageState createState() => _SetPermanentPasswordPageState();
}

class _SetPermanentPasswordPageState extends State<SetPermanentPasswordPage> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  void _setPermanentPassword() async {
    if (_formKey.currentState!.validate()) {
      final password = passwordController.text;

      try {
        final response = await SetPasswordApiService.setPassword(widget.userId, password);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response),
          backgroundColor: Colors.green,
        ));

        // Navigate to LoginPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UiPage()),
              (Route<dynamic> route) => false,
        );
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

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(
                              'Enter Permanent Password ',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.indigoAccent),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Permanent Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter your permanent password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context, '', ''),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  onPressed: _setPermanentPassword,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      "Set password".toUpperCase(),
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
