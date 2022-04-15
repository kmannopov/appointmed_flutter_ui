import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/screens/appointment_screens/appointment_list.dart';
import 'package:appointmed/src/screens/doctor_screens/doctor_profile.dart';
import 'package:appointmed/src/screens/doctor_screens/doctor_welcome_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  final List<Widget> _pages = [
    const DoctorWorkplacePage(),
    const AppointmentList(role: "Doctor"),
    const DoctorProfile()
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
              title: const FittedBox(
                  fit: BoxFit.scaleDown, child: Text('Appointments')),
              icon: const Icon(Icons.event_note_rounded),
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              activeColor: Palette.primary,
              inactiveColor: Colors.black,
              title: const Text('Account'),
              icon: const Icon(Icons.manage_accounts_rounded),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
