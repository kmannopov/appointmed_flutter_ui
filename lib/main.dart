import 'dart:io';

import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/screens/utility_screens/restart.dart';
import 'package:appointmed/src/screens/utility_screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HttpOverrides.global = MyHttpOverrides();

  runApp(
    RestartWidget(
      child: MaterialApp(
        title: "AppointMed",
        theme: ThemeData(
          primarySwatch: Palette.primary,
          scaffoldBackgroundColor: Palette.scaffoldColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    ),
  );
}
