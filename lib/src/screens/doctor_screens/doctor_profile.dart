import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/extensions/input_validators.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:appointmed/src/repositories/doctor_repository.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/input_widget.dart';
import 'package:appointmed/src/screens/utility_screens/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:showcaseview/showcaseview.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key}) : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final _doctorRepository = DoctorRepository();
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();

  late String firstNameText, lastNameText, phoneText;
  String? genderText;
  Doctor? doctor;

  @override
  void initState() {
    super.initState();
    getDoctorInfo();
  }

  void getDoctorInfo() async {
    var userId = await storage.read(key: 'userId');
    try {
      doctor = await _doctorRepository.getDoctorById(userId!);
      setState(() {
        _firstName.text = doctor!.firstName;
        _lastName.text = doctor!.lastName;
        _phone.text = doctor!.phoneNumber;
        firstNameText = doctor!.firstName;
        lastNameText = doctor!.lastName;
        phoneText = doctor!.phoneNumber;
        genderText = doctor!.gender;
      });
    } catch (error) {
      ErrorDialog.show(context: context, message: error.toString());
    }
  }

  void updateDoctorInfo() async {
    try {
      var success = await _doctorRepository.updateDoctor(Doctor(
          firstName: firstNameText,
          lastName: lastNameText,
          dateOfBirth: doctor!.dateOfBirth,
          gender: genderText!,
          phoneNumber: phoneText,
          email: doctor!.email));
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Updated Successfully!')));
        getDoctorInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something Went Wrong.')));
      }
    } catch (error) {
      ErrorDialog.show(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: ShowCaseWidget(
                          builder: Builder(
                              builder: (context) => const GetStartedScreen()),
                        ),
                        type: PageTransitionType.rightToLeftWithFade));
                storage.deleteAll();
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
          title: const Text(
            'PATIENT PROFILE',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Palette.scaffoldColor,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: doctor != null
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(genderText == 'Male'
                                ? 'assets/images/man.png'
                                : 'assets/images/woman.png'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //! First Name
                              InputWidget(
                                  controller: _firstName,
                                  updateValue: (value) {
                                    firstNameText = value;
                                  },
                                  hintText: "First Name*",
                                  validator: InputValidators.textValidate),

                              //! Last Name
                              InputWidget(
                                  controller: _lastName,
                                  updateValue: (value) {
                                    lastNameText = value;
                                  },
                                  hintText: "Last Name*",
                                  validator: InputValidators.textValidate),

                              //! Gender
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                  label: const Text("Choose Gender*"),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                validator: (value) => value == null
                                    ? 'Field must not be empty'
                                    : null,
                                isExpanded: true,
                                value: genderText,
                                items: [
                                  'Male',
                                  'Female',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    genderText = value!;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              //! User Phone
                              InputWidget(
                                  controller: _phone,
                                  updateValue: (value) {
                                    phoneText = value;
                                  },
                                  hintText: "Phone Number*",
                                  validator: InputValidators.phoneValidate),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              updateDoctorInfo();
                            }

                            FocusScope.of(context).unfocus();
                          },
                          child: const Text(
                            'Update',
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            )),
                            minimumSize: MaterialStateProperty.all<Size>(Size(
                                MediaQuery.of(context).size.width * 0.9, 65)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
