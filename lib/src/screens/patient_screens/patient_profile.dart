import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/extensions/input_validators.dart';
import 'package:appointmed/src/models/address.dart';
import 'package:appointmed/src/models/patient.dart';
import 'package:appointmed/src/repositories/patient_repository.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/input_widget.dart';
import 'package:appointmed/src/screens/utility_screens/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:showcaseview/showcaseview.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({Key? key}) : super(key: key);

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  _PatientProfileState();
  final _patientRepository = PatientRepository();
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _region = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _street = TextEditingController();

  late String firstNameText,
      lastNameText,
      phoneText,
      regionText,
      cityText,
      districtText,
      streetText;
  String? genderText;
  Patient? patient;

  @override
  void initState() {
    super.initState();
    getPatientInfo();
  }

  void getPatientInfo() async {
    var userId = await storage.read(key: 'userId');
    try {
      patient = await _patientRepository.getPatientById(userId!);
      setState(() {
        _firstName.text = patient!.firstName;
        _lastName.text = patient!.lastName;
        _phone.text = patient!.phoneNumber;
        _region.text = patient!.address.region;
        _city.text = patient!.address.city;
        _district.text = patient!.address.district;
        _street.text = patient!.address.street;
        firstNameText = patient!.firstName;
        lastNameText = patient!.lastName;
        phoneText = patient!.phoneNumber;
        regionText = patient!.address.region;
        cityText = patient!.address.city;
        districtText = patient!.address.district;
        streetText = patient!.address.street;
        genderText = patient!.gender;
      });
    } catch (error) {
      ErrorDialog.show(context: context, message: error.toString());
    }
  }

  void updatePatientInfo() async {
    try {
      var success = await _patientRepository.updatePatient(Patient(
          firstName: firstNameText,
          lastName: lastNameText,
          dateOfBirth: patient!.dateOfBirth,
          gender: genderText!,
          address: Address(
              city: cityText,
              district: districtText,
              region: regionText,
              street: streetText,
              latitude: 12.123123,
              longitude: 12.123123),
          phoneNumber: phoneText,
          email: patient!.email));
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Updated Successfully!')));
        getPatientInfo();
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
        body: patient != null
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

                              //! Region
                              InputWidget(
                                  controller: _region,
                                  updateValue: (value) {
                                    regionText = value;
                                  },
                                  hintText: "Region*",
                                  validator: InputValidators.textValidate),
                              //! City
                              InputWidget(
                                  controller: _city,
                                  updateValue: (value) {
                                    cityText = value;
                                  },
                                  hintText: "City*",
                                  validator: InputValidators.textValidate),

                              //! District
                              InputWidget(
                                  controller: _district,
                                  updateValue: (value) {
                                    districtText = value;
                                  },
                                  hintText: "District*",
                                  validator: InputValidators.textValidate),

                              //! Street
                              InputWidget(
                                  controller: _street,
                                  updateValue: (value) {
                                    streetText = value;
                                  },
                                  hintText: "Street*",
                                  validator: InputValidators.textValidate),
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
                              updatePatientInfo();
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
