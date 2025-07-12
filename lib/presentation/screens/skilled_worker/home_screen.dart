import 'package:flutter/material.dart';
import 'jobs_screen.dart';
import 'home_profile_screen.dart';

class SkilledWorkerHomeScreen extends StatefulWidget {
  const SkilledWorkerHomeScreen({super.key});

  @override
  State<SkilledWorkerHomeScreen> createState() =>
      _SkilledWorkerHomeScreenState();
}

class _SkilledWorkerHomeScreenState extends State<SkilledWorkerHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SkilledWorkerJobsScreen(),
    SkilledWorkerHomeProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
