import 'package:flutter/material.dart';

class AppointmentDetails extends StatefulWidget {
  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APPOINTMENT DETAILS',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
          flexibleSpace: Container(
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
            ),
          ),
          centerTitle: true
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
