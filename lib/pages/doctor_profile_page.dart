import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/docprofile.dart';
import 'package:flutter_login_ui/pages/studentrequestspage.dart';
import 'package:flutter_login_ui/pages/studprescription.dart';
import 'package:flutter_login_ui/pages/AppointmentDetails.dart';
import 'package:flutter_login_ui/pages/ui_page_logins.dart';
import 'package:flutter_login_ui/pages/viewrequestdemo.dart';
import 'package:flutter_login_ui/pages/viewrequestdemo2.dart';
import 'package:flutter_login_ui/pages/viewrequests.dart';
// import 'package:flutter_login_ui/pages/prescriptionformpage.dart'; // Import PrescriptionFormPage

void main() {
  runApp(DocApp());
}

class DocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DoctorHomePage(),
    );
  }
}

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selectedIndex = 0;

  static  List<Widget> _pages = <Widget>[
    DocProfilePage(),
    StudentRequestsScreen(),
    // ViewRequestPage()// Add PrescriptionFormPage here
    // Add ProfilePage widget here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY PROFILE',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Requests',
          ),
        ],
      ),
    );
  }
}
