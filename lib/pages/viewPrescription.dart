import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/viewprescriptionModel.dart';
import 'package:flutter_login_ui/services/viewprescriptionService.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(ViewPrescription());
}

class ViewPrescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrescriptionScreen(),
    );
  }
}

class PrescriptionScreen extends StatefulWidget {
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  String _userId = '';
  List<Prescription> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('_id') ?? '';
    });
    _fetchPrescriptions();
  }

  _fetchPrescriptions() async {
    try {
      final prescriptions = await PrescriptionService.getPrescriptions(_userId);
      setState(() {
        _prescriptions = prescriptions;
      });
    } catch (e) {
      print('Error loading prescriptions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PRESCRIPTION DETAILS', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
          backgroundColor: Colors.transparent,
          // Make AppBar background transparent
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
      body: _prescriptions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.withOpacity(0.6), Colors.indigo.withOpacity(0.6), Colors.indigoAccent.withOpacity(0.6)],
                  // Set your gradient colors
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(
                    10.0), // Optional: Set border radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _prescriptions!= null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor Notes: ${_prescriptions[index].doctorNotes}', style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),),
                    Text('Medicine: ${_prescriptions[index].medicine}',
                      style: TextStyle(fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),),
                    Text('Dosage: ${_prescriptions[index].dosage}', style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),),
                    Text('Instructions: ${_prescriptions[index].instructions}', style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),),
                  ],
                )
                    : Text('Failed to load student details'),
              ),
            ),
          );
          // return ListTile(
          //   title: Text('Doctor Notes: ${_prescriptions[index].doctorNotes}'),
          //   subtitle: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text('Medicine: ${_prescriptions[index].medicine}'),
          //       Text('Dosage: ${_prescriptions[index].dosage}'),
          //       Text('Instructions: ${_prescriptions[index].instructions}'),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }
}
