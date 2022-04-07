import 'package:appointmed/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'doctor_page.dart';
import 'home_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [
    const HomePage(),
    const DoctorPage(),
    //const ChatPage(),
    Container(),
    Container()
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
              title: const Text('Doctor'),
              icon: const Icon(Icons.medical_services_rounded),
              textAlign: TextAlign.center),
          // BottomNavyBarItem(
          //     activeColor: Palette.primary,
          //     inactiveColor: Colors.black,
          //     title: const Text('Chat'),
          //     icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
          //     textAlign: TextAlign.center),
          BottomNavyBarItem(
              activeColor: Palette.primary,
              inactiveColor: Colors.black,
              title: const Text('Booking'),
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
