import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/adminlogin.dart';
import 'login_doc_page.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';

class UiPage extends StatefulWidget {
  const UiPage({Key? key}) : super(key: key);

  @override
  _UiPageState createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {
  double _headerHeight = 250;
  PageController _pageController = PageController(initialPage: 0); // Initialize PageController

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // Swiped right
                _pageController.previousPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              } else if (details.primaryVelocity! < 0) {
                // Swiped left
                _pageController.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
            child: Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, CircleAvatar(
                backgroundImage: AssetImage('images/logo_letter_box_med.png'),
                radius: 60,
                backgroundColor: Colors.white,
              )),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController, // Assign PageController to PageView
              children: [
                StudLoginPage(), // First page for student login
                DocLoginPage(),
                AdminLoginPage()// Second page for doctor login
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease); // Navigate to first page (Student Login)
                },
                child: Text('Student Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease); // Navigate to second page (Doctor Login)
                },
                child: Text('Doctor Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.ease); // Navigate to second page (Doctor Login)
                },
                child: Text('Admin Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}