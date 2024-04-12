import 'package:flutter/material.dart';

class BottomNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation'),
      ),
      body: Center(
        child: Text('Welcome to Bottom Navigation Page'),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}
