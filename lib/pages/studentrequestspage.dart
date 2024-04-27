import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late DateTime _selectedDate;
  String? _selectedTimeSlot;
  List<String> _availableTimeSlots = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _admissionNumberController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();

  String? _userId; // Declare _userId variable to hold the user ID

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchDoctorLeaveDates();
    _fetchConsultationDays();
    _selectedTimeSlot = null;

    // Fetch user ID from SharedPreferences
    _getUserID();
  }

  Future<void> _getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('_id');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _admissionNumberController.dispose();
    _diseaseController.dispose();
    super.dispose();
  }

  Future<List<DateTime>> _fetchDoctorLeaveDates() async {
    final response = await http.get(
      Uri.parse('http://localhost:3006/api/student/api/doctor-leave-dates'),
    );

    print("Doctor Leave Dates : " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<DateTime> leaveDates = [];
      for (dynamic item in data) {
        if (item['date'] != null) {
          String dateString = item['date'];
          DateTime? date = DateTime.tryParse(dateString);
          if (date != null) {
            DateTime dateOnly = DateTime(date.year, date.month, date.day);
            leaveDates.add(dateOnly);
          } else {
            print('Invalid date format: $dateString');
          }
        }
      }
      return leaveDates;
    } else {
      throw Exception('Failed to fetch doctor leave dates');
    }
  }

  Future<List<DateTime>> _fetchConsultationDays() async {
    final response = await http.get(
      Uri.parse('http://localhost:3006/api/student/api/consultation-days'),
    );
    print("consultation : " + response.statusCode.toString());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<DateTime> consultationDays = data.map((date) => DateTime.parse(date.toString())).toList();
      return consultationDays;
    } else {
      throw Exception('Failed to fetch consultation days');
    }
  }

  Future<void> _fetchAvailableTimeSlots(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print('Selected Date: $formattedDate'); // Debugging statement to check the selected date
    final response = await http.post(
      Uri.parse('http://localhost:3006/api/student/api/available-time-slots'),
      body: jsonEncode({'date': formattedDate}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _availableTimeSlots = data.map((slot) => slot.toString()).toList();
      });
    } else {
      throw Exception('Failed to fetch available time slots');
    }
  }

  Future<void> _bookAppointment() async {
    if (_formKey.currentState!.validate()) {
      // Validate the form fields
      Map<String, dynamic> appointmentData = {
        'userId': _userId, // Use _userId instead of _userIdController.text
        'name': _nameController.text,
        'admissionNumber': _admissionNumberController.text,
        'disease': _diseaseController.text,
        'date': _selectedDate.toIso8601String(),
        'timeSlot': _convertTo24HourFormat(_selectedTimeSlot!),
      };

      try {
        await _postAppointment(appointmentData);
        // Handle successful booking
      } catch (error) {
        // Handle booking failure
      }
    }
  }

  String _convertTo24HourFormat(String timeSlot) {
    print("timeSlot : " + timeSlot);
    List<String> parts = timeSlot.split(','); // Split by comma
    String startTime = _convertTo24Hour(parts[0].trim()); // Convert start time
    String endTime = _convertTo24Hour(parts[1].trim()); // Convert end time
    print("startTime : " + startTime);
    print("endTime : " + endTime);
    return '$startTime - $endTime';
  }

  String _convertTo24Hour(String time) {
    List<String> parts = time.split(' ');
    String timePart = parts[0];
    String period = parts[1];
    List<String> timeParts = timePart.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    if (period == 'PM' && hours != 12) {
      hours += 12;
    } else if (period == 'AM' && hours == 12) {
      hours = 0;
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  Future<void> _postAppointment(Map<String, dynamic> appointmentData) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3006/api/student/student-request'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(appointmentData),
      );

      if (response.statusCode == 201) {
        // Handle successful booking
        print('Appointment booked successfully');
      } else {
        // Handle booking failure
        print('Failed to book appointment: ${response.body}');
      }
    } catch (error) {
      // Handle error
      print('Error booking appointment: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(strokeWidth: 1),
          SizedBox(height: 8),
          Text("Loading..."),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => loadingDialog,
      barrierDismissible: false,
    );
    void updateLoadingDialog(String latestLeaveDate) {
      AlertDialog updatedDialog = AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info, color: Colors.red, size: 16.0),
                  SizedBox(width: 8.0),
                  Text(
                    "Doctor Leave: $latestLeaveDate",
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            CircularProgressIndicator(strokeWidth: 1),
            SizedBox(height: 8),
            Text("Loading..."),
          ],
        ),
      );
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return updatedDialog;
        },
        barrierDismissible: false,
      );
    }

    List<DateTime> doctorLeaveDates = await _fetchDoctorLeaveDates();
    final List<DateTime> consultationDays = await _fetchConsultationDays();
    String latestLeaveDate = doctorLeaveDates.isNotEmpty ? DateFormat('yyyy-MM-dd').format(doctorLeaveDates.last) : 'No leave dates';
    updateLoadingDialog(latestLeaveDate);
    Navigator.pop(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 14 * 30)),
      builder: (BuildContext context, child) {
        return Column(
          children: [
            SizedBox(
              height: 180.0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 45.0),
                    Text(
                      "Doctor Leave: $latestLeaveDate",
                      style: TextStyle(color: Colors.black, fontSize: 25.0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: child!,
            ),
          ],
        );
      },
      selectableDayPredicate: (DateTime date) {
        if (doctorLeaveDates.any((leaveDate) => _isSameDay(leaveDate, date))) {
          return false;
        }
        if (consultationDays.any((consultationDate) => _isSameDay(consultationDate, date))) {
          return true;
        }
        return false;
      },
    );

    if (picked != null) {
      _selectedDate = picked;
      await _fetchAvailableTimeSlots(_selectedDate!);
      _showTimeSlotsDialog();
    }
  }

  void _showTimeSlotsDialog() {
    List<String> timeSlots = _availableTimeSlots.map((slot) {
      String formattedSlot = slot
          .replaceAll('{startTime:', '')
          .replaceAll('endTime:', '')
          .replaceAll('-', '')
          .replaceAll('}', '');
      return formattedSlot.trim();
    }).toList();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: timeSlots.map((slot) {
              return ListTile(
                title: Text(slot),
                onTap: () {
                  _selectedTimeSlot = slot;
                  setState(() {});
                  Navigator.pop(context);
                  _showConfirmationDialog();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}\nSelected Time Slot: $_selectedTimeSlot'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform any action needed with the selected date and time slot
                // For example, call a function to save the appointment
                // saveAppointment(_selectedDate, _selectedTimeSlot);
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
  void _selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('BOOK APPOINTMENT',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.white),),backgroundColor: Colors.transparent, // Make AppBar background transparent
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Enter Appointment Details',
                //   style: TextStyle(fontSize: 20),
                // ),
                TextFormField(
                  controller: _nameController,
                  decoration:ThemeHelper().textInputDecoration('Name', 'Enter your name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _admissionNumberController,
                  decoration:ThemeHelper().textInputDecoration('AdmNo/EmpId', 'Enter your admission number or Employee Id'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Admission Number/';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _diseaseController,
                  decoration:ThemeHelper().textInputDecoration('Disease', 'Enter disease'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Disease';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: Icon(Icons.date_range),
                  label: Text('Select Date'),
                ),
                SizedBox(height: 20),
                if (_selectedDate != null && _selectedTimeSlot != null)
                  Text(
                    "Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}\nSelected Time Slot: $_selectedTimeSlot",
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20.0),
                Container(
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
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: ElevatedButton(
                    style: ThemeHelper().buttonStyle(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text(
                        'submit'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () => _bookAppointment(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
