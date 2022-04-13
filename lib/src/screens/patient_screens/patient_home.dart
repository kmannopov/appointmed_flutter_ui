import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/screens/patient_screens/patient_profile.dart';
import 'package:appointmed/src/screens/patient_screens/patient_welcome_screen.dart';
import 'package:appointmed/src/screens/schedule_screens/select_category.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({Key? key}) : super(key: key);

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final List<Widget> _pages = [
    const PatientWelcomePage(),
    Container(),
    const SelectCategoryScreen(),
    Container(),
    const PatientProfile(),
  ];

  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _pages),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: Palette.primary,
              inactiveColor: Colors.black,
              title: const Text('Home'),
              icon: const Icon(Icons.home),
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              activeColor: Palette.primary,
              inactiveColor: Colors.black,
              title: const Text('Clinics'),
              icon: const Icon(Icons.business),
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              activeColor: Palette.primary,
              inactiveColor: Colors.black,
              title: const Text('Schedule'),
              icon: const Icon(Icons.add_box),
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              activeColor: Palette.primary,
              inactiveColor: Colors.black,
              title: const Text('History'),
              icon: const Icon(Icons.event_note_rounded),
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              activeColor: Palette.primary,
              inactiveColor: Colors.black,
              title: const Text('Profile'),
              icon: const Icon(Icons.manage_accounts_rounded),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
