import 'package:appointmed/config/palette.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TERMS AND CONDITIONS',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Palette.scaffoldColor,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const SingleChildScrollView(
          child: Text("Terms and Conditions"),
        ),
      ),
    );
  }
}
