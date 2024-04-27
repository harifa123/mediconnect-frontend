import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_login_ui/models/viewprescriptionModel.dart';
import 'package:flutter_login_ui/services/viewprescriptionService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart' show ByteData, rootBundle;

Future<Uint8List> _readImageData(String path) async {
  final ByteData data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}

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

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    // Add college emblem image
    final Uint8List emblemImage = await _readImageData('images/images.png'); // Adjust path as needed
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Column(
              children: [
                pw.Image(
                  pw.MemoryImage(emblemImage),
                  width: 150, // Adjust width as needed
                  height: 150, // Adjust height as needed
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'FEDERAL INSTITUTE OF SCIENCE AND TECHNOLOGY\nPrescription Details\n',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold,),textAlign:pw.TextAlign.center
                ),
                pw.SizedBox(height: 20),
                // Add prescriptions
                for (var prescription in _prescriptions)
                  pw.Container(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Doctor Notes: ${prescription.doctorNotes}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Medicine: ${prescription.medicine}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Dosage: ${prescription.dosage}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Instructions: ${prescription.instructions}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PRESCRIPTION DETAILS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
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
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor Notes: ${_prescriptions[index].doctorNotes}', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Medicine: ${_prescriptions[index].medicine}', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Dosage: ${_prescriptions[index].dosage}', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Instructions: ${_prescriptions[index].instructions}', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pdfBytes = await generatePdf();
          final blob = html.Blob([pdfBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'prescriptions.pdf')
            ..click();
          html.Url.revokeObjectUrl(url);
        },
        child: Icon(Icons.file_download),
      ),
    );
  }
}
