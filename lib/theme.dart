import 'package:flutter/material.dart';

class CustomTheme {
  const CustomTheme();

  static const Color loginGradientStart = Color.fromRGBO(55, 81, 255, 1);
  static const Color loginGradientEnd = Color.fromRGBO(2, 196, 237, 1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[loginGradientStart, loginGradientEnd],
    stops: <double>[0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
