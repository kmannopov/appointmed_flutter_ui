import 'dart:async';

import 'package:appointmed/src/screens/doctor_screens/doctor_home.dart';
import 'package:appointmed/src/screens/patient_screens/patient_home.dart';
import 'package:appointmed/src/screens/utility_screens/get_started.dart';
import 'package:appointmed/src/screens/utility_screens/offline.dart';
import 'package:appointmed/src/screens/utility_screens/onboard.dart';
import 'package:connectivity/connectivity.dart';
import 'package:appointmed/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;
  final storage = const FlutterSecureStorage();

  bool connection = true;
  late Connectivity connectivity;

  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connection = false;
        });
      }
    });
    _loadWidget();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  _loadWidget() {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isViewed = prefs.getInt('onBoard');
    var role = await storage.read(key: 'role');

    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: connection
            ? const Offline()
            : isViewed != 0
                ? const OnBoard()
                : Builder(
                    builder: (context) {
                      if (role == 'Doctor') {
                        return ShowCaseWidget(
                          builder:
                              Builder(builder: (context) => const DoctorHome()),
                        );
                      } else if (role == 'Patient') {
                        return ShowCaseWidget(
                          builder: Builder(
                              builder: (context) => const PatientHome()),
                        );
                      } else if (role == null) {
                        return const GetStartedScreen();
                      }
                      return const GetStartedScreen();
                    },
                  ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Palette.scaffoldColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Image(
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('Version: 1.0.0'),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
