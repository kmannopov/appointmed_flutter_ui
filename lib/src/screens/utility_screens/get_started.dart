import 'package:appointmed/src/screens/auth_screens/login_screen.dart';
import 'package:appointmed/src/screens/auth_screens/doctor_registration_screen.dart';
import 'package:appointmed/src/screens/auth_screens/patient_registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.red,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),

                //! Login Button
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 30),
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      print('pressed on login');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const LoginScreen(),
                              type: PageTransitionType.rightToLeftWithFade));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 40),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 40),
                  child: const Text(
                    "Sign up by choosing your role.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                //! Doctor Signup Button
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    storage.write(key: 'role', value: 'Doctor');
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: const DoctorRegistrationScreen()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              padding: const EdgeInsets.only(top: 10, left: 20),
                              child: const FaIcon(
                                FontAwesomeIcons.userDoctor,
                                size: 85,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: const Text(
                                "I'm a doctor",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const Center(
                          child: Icon(
                            Icons.chevron_right_outlined,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),

                //! Patient Signup Button
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    storage.write(key: 'role', value: 'Patient');
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const PatientRegistrationScreen(),
                            type: PageTransitionType.rightToLeftWithFade));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: const FaIcon(
                                FontAwesomeIcons.bedPulse,
                                size: 85,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: const Text(
                                "I'm a patient",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const Center(
                          child: Icon(
                            Icons.chevron_right_outlined,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
