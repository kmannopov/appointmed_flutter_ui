import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/screens/utility_screens/restart.dart';
import 'package:appointmed/src/screens/utility_screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //runApp(App());
  runApp(
    RestartWidget(
      child: MaterialApp(
        title: "AppointMed",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Palette.scaffoldColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    ),
  );
}
