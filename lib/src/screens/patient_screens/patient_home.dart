import 'dart:convert';

import 'package:appointmed/src/screens/patient_screens/patient_profile.dart';
import 'package:appointmed/src/screens/utility_screens/get_started.dart';
import 'package:appointmed/src/screens/utility_screens/privacy_policy.dart';
import 'package:appointmed/src/screens/utility_screens/terms_and_conditions.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class PatientHome extends StatefulWidget {
  final String userID;
  const PatientHome(this.userID, {Key? key}) : super(key: key);

  @override
  _PatientHomeState createState() => _PatientHomeState(userID);
}

class _PatientHomeState extends State<PatientHome> {
  final String userID;
  _PatientHomeState(this.userID);

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _coronaKey = GlobalKey();
  final GlobalKey _newsKey = GlobalKey();
  final GlobalKey _bmiKey = GlobalKey();
  final GlobalKey _seeAllDoctorKey = GlobalKey();

  DateTime timeBackPressed = DateTime.now();

  late Map data;
  late List doctors;
  late List quotes;

  late String userGender;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getDoctorQuotes();
    getDoctors();
  }

  getUserDetails() async {
    final String url = 'https://bcrecapc.ml/api/user/$userID/';
    var response = await http.get(Uri.parse(url));
    if (!mounted) return;
    setState(() {
      var convertJson = json.decode(response.body);
      data = convertJson;
      userGender = data['user_gender'];
    });
    print(userGender);
  }

  getDoctorQuotes() async {
    const String url =
        'https://samwitadhikary.github.io/doctor_quote/doctor_quote.json';
    var response = await http.get(Uri.parse(url));
    if (!mounted) return;
    setState(() {
      var convertJson = json.decode(response.body);
      quotes = convertJson['quotes'];
    });
  }

  getDoctors() async {
    const String url = 'https://bcrecapc.ml/api/chamberdoctor/';
    var response = await http.get(Uri.parse(url));
    if (!mounted) return;
    setState(() {
      var convertJson = json.decode(response.body);
      doctors = convertJson;
      print(doctors);
    });
  }

  @override
  Widget build(BuildContext context) {
    displayShowCase() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? showCaseVisibilityStatus = prefs.getBool('displayShowCase');

      if (showCaseVisibilityStatus == null) {
        prefs.setBool('displayShowCase', false);
        return true;
      }
      return false;
    }

    Future.delayed(const Duration(seconds: 2), () {
      displayShowCase().then((status) {
        if (status) {
          ShowCaseWidget.of(context)!.startShowCase([
            _menuKey,
            _coronaKey,
            _newsKey,
            _bmiKey,
            _seeAllDoctorKey,
          ]);
        }
      });
    });

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          timeBackPressed = DateTime.now();
          if (difference >= const Duration(seconds: 2)) {
            const String msg = 'Press the back button to exit';
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text(msg)));
            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                ListTile(
                  title: const Text(
                    'User Profile',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  leading: const FaIcon(FontAwesomeIcons.penClip),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: PatientProfile(userID),
                            type: PageTransitionType.rightToLeft));
                  },
                ),
                // ListTile(
                //   title: Text(
                //     'Your Appointments',
                //     style: TextStyle(
                //       fontSize: 15,
                //     ),
                //   ),
                //   leading: Icon(
                //     Icons.calendar_today,
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         PageTransition(
                //             child: UserAppointment(userID),
                //             type: PageTransitionType.rightToLeftWithFade));
                //   },
                // ),
                ListTile(
                  title: const Text('Terms & Conditions',
                      style: TextStyle(fontSize: 15)),
                  leading: const Icon(Icons.note_alt_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: TermsAndConditions(),
                            type: PageTransitionType.rightToLeft));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  leading: const Icon(Icons.lock),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: PrivacyPolicy(),
                            type: PageTransitionType.rightToLeft));
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('LogOut'),
                  leading: const Icon(Icons.logout),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('role');
                    prefs.remove('userId');
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRightWithFade,
                            child: GetStartedScreen()));
                  },
                ),
              ],
            ),
          ),
          key: _scaffoldState,
          body: data != null
              ? Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 65,
                                      top: 10,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                            'Welcome',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data['user_name'] != null
                                                ? data['user_name']
                                                : 'User',
                                            style: const TextStyle(
                                              fontSize: 19,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      image: DecorationImage(
                                          image: AssetImage(userGender == 'Male'
                                              ? 'assets/images/man.png'
                                              : 'assets/images/woman.png')),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //! Corona Stats
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         PageTransition(
                                  //             child: CoronaStats(),
                                  //             type: PageTransitionType
                                  //                 .rightToLeftWithFade));
                                  //   },
                                  //   child: Showcase(
                                  //     key: _coronaKey,
                                  //     description: 'Check covid-19 status',
                                  //     child: Container(
                                  //       height: 105,
                                  //       width: 105,
                                  //       decoration: BoxDecoration(
                                  //         color: Palette.scaffoldColor,
                                  //         border: Border.all(),
                                  //         borderRadius:
                                  //             BorderRadius.circular(20),
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             blurRadius: 5,
                                  //             color:
                                  //                 Colors.grey.withOpacity(0.5),
                                  //             offset: Offset(5, 5),
                                  //           )
                                  //         ],
                                  //       ),
                                  //       child: Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           FaIcon(
                                  //             FontAwesomeIcons.viruses,
                                  //             size: 40,
                                  //           ),
                                  //           SizedBox(
                                  //             height: 10,
                                  //           ),
                                  //           Text('Corona Stats')
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  //! News
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         PageTransition(
                                  //             child: News(),
                                  //             type: PageTransitionType
                                  //                 .rightToLeftWithFade));
                                  //   },
                                  //   child: Showcase(
                                  //     key: _newsKey,
                                  //     description:
                                  //         'Read all trending medical and health news',
                                  //     child: Container(
                                  //       height: 105,
                                  //       width: 105,
                                  //       decoration: BoxDecoration(
                                  //         color: Palette.scaffoldColor,
                                  //         border: Border.all(),
                                  //         borderRadius:
                                  //             BorderRadius.circular(20),
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             blurRadius: 5,
                                  //             color:
                                  //                 Colors.grey.withOpacity(0.5),
                                  //             offset: Offset(5, 5),
                                  //           )
                                  //         ],
                                  //       ),
                                  //       child: Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           FaIcon(
                                  //             FontAwesomeIcons.newspaper,
                                  //             size: 40,
                                  //           ),
                                  //           SizedBox(
                                  //             height: 10,
                                  //           ),
                                  //           Text('News')
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  //! BMI
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         PageTransition(
                                  //             child: InputPage(),
                                  //             type: PageTransitionType
                                  //                 .rightToLeft));
                                  //   },
                                  //   child: Showcase(
                                  //     key: _bmiKey,
                                  //     description: 'Check your Body Mass Index',
                                  //     child: Container(
                                  //       height: 105,
                                  //       width: 105,
                                  //       decoration: BoxDecoration(
                                  //         color: Palette.scaffoldColor,
                                  //         border: Border.all(),
                                  //         borderRadius:
                                  //             BorderRadius.circular(20),
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             blurRadius: 5,
                                  //             color:
                                  //                 Colors.grey.withOpacity(0.5),
                                  //             offset: Offset(5, 5),
                                  //           )
                                  //         ],
                                  //       ),
                                  //       child: Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           FaIcon(
                                  //             FontAwesomeIcons.weight,
                                  //             size: 40,
                                  //           ),
                                  //           SizedBox(
                                  //             height: 10,
                                  //           ),
                                  //           Text('BMI')
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              // color: Colors.pink,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: quotes != null
                                  ? CarouselSlider.builder(
                                      itemCount: quotes.length,
                                      options: CarouselOptions(
                                        aspectRatio: 3.0,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 6),
                                      ),
                                      itemBuilder: (BuildContext context,
                                          int index, int pageViewIndex) {
                                        final quote = quotes[index];
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          padding: const EdgeInsets.all(20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AutoSizeText(
                                                quote['quote'],
                                                maxLines: 3,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  '~ ' + quote['author'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 150,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 25),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    child: const Text(
                                      'Available Doctors',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         PageTransition(
                                  //             child: AllAvailableDoctors(
                                  //                 userID, data['user_name']),
                                  //             type: PageTransitionType
                                  //                 .rightToLeftWithFade));
                                  //   },
                                  //   child: Container(
                                  //     padding: EdgeInsets.only(right: 20),
                                  //     child: Showcase(
                                  //       key: _seeAllDoctorKey,
                                  //       description:
                                  //           'See all available doctors',
                                  //       child: Text(
                                  //         'See All >',
                                  //         style: TextStyle(fontSize: 18),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),

                            //! Available Doctors List
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context).size.height * 0.34,
                              child: doctors != null
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        final doctor = doctors[index];
                                        return GestureDetector(
                                          onTap: () {
                                            print(doctor['doctor_name']);
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeftWithFade,
                                                    child: const Text("TODO")));
                                            // child: AboutDoctor(
                                            //     doctor[
                                            //         'registration_id'],
                                            //     userID,
                                            //     doctor['doctor_name'],
                                            //     doctor['doctor_gender'],
                                            //     data['user_name'],
                                            //     doctor[
                                            //         'doctor_description'],
                                            //     doctor['degree'],
                                            //     doctor['designation'],
                                            //     doctor['mail_id'],
                                            //     doctor['phone_no'],
                                            //     data['phone_no'])));
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    image: DecorationImage(
                                                      image: doctor[
                                                                  'doctor_gender'] ==
                                                              'Female'
                                                          ? const AssetImage(
                                                              'assets/images/doctor.png',
                                                            )
                                                          : const AssetImage(
                                                              'assets/images/doctor-male.png',
                                                            ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Dr. ' +
                                                          doctor['doctor_name'],
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(doctor['degree']),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(doctor[
                                                            'designation'])
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.34,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      )),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 30,
                      child: Showcase(
                        key: _menuKey,
                        description: 'Click here for more options',
                        child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () =>
                              _scaffoldState.currentState!.openDrawer(),
                        ),
                      ),
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
