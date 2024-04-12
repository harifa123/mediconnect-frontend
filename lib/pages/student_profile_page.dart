import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:flutter_login_ui/pages/studentViewpage.dart';
import 'package:flutter_login_ui/pages/studentrequestspage.dart';
import 'package:flutter_login_ui/pages/studprescription.dart';
import 'package:flutter_login_ui/pages/AppointmentDetails.dart';
import 'package:flutter_login_ui/pages/ui_page_logins.dart';
import 'package:flutter_login_ui/pages/viewPrescription.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentHomePage(),
    );
  }
}
class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages; // Declare _pages as late to ensure it's initialized in initState

  @override
  void initState() {
    super.initState();
    _pages = [StudentDetailsPage(), StudentRequestPage(), ViewPrescription()];
  }

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
            // icon: Icon(Icons.person,color: Colors.purple.withOpacity(0.5)),
            icon: Icon(Icons.person, color: Colors.indigoAccent),
            label: ('Profile'),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page,color: Colors.indigoAccent),
            label: 'Book Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle,color: Colors.indigoAccent),
            label: 'Prescription',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.details,color: Colors.indigoAccent),
          //   label: 'Appointment Details',
          // ),
        ],
        selectedLabelStyle: TextStyle(color: Colors.purple),
        // Set the unselected label style
        unselectedLabelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
