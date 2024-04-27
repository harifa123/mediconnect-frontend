import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/ui_page_logins.dart';

class DocProfilePage extends StatefulWidget {
  @override
  _DocProfilePageState createState() => _DocProfilePageState();
}

class _DocProfilePageState extends State<DocProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY INFO',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: 250,
          padding: EdgeInsets.all(40.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: Dr. Anoop',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.indigo),
              ),
              SizedBox(height: 10),
              Text(
                'Age: 40',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.indigo),
              ),
              SizedBox(height: 10),
              Text(
                'Email: doc@gmail.com',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.indigo),
              ),
              SizedBox(height: 10),
              Text(
                'Specialization: Internal Medicine',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.indigo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
