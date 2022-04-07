import 'package:appointmed/src/models/address.dart';
import 'package:appointmed/src/models/auth/register_request.dart';
import 'package:appointmed/src/models/patient.dart';
import 'package:appointmed/src/repositories/auth_repository.dart';
import 'package:appointmed/src/extensions/input_validators.dart';
import 'package:appointmed/src/repositories/patient_repository.dart';
import 'package:appointmed/src/screens/auth_screens/login_screen.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/date_picker.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/input_widget.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/password_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({Key? key}) : super(key: key);

  @override
  _PatientRegistrationScreenState createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();
  final _patientRepository = PatientRepository();
  bool isLogin = false;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _region = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _street = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final String role = 'Patient';

  String? firstNameText,
      lastNameText,
      genderText,
      emailText,
      phoneText,
      regionText,
      cityText,
      districtText,
      streetText,
      passwordText,
      confirmPasswordText;
  DateTime? dateOfBirth;

  void _registerPatient() async {
    try {
      setState(() {
        isLogin = true;
      });

      var result = await _authRepository.register(RegisterRequest(
          email: emailText!, password: passwordText!, role: role));

      if (result) {
        var newPatient = await _patientRepository.registerPatient(Patient(
            firstName: firstNameText!,
            lastName: lastNameText!,
            dateOfBirth: dateOfBirth!,
            gender: genderText!,
            address: Address(
                city: cityText!,
                district: districtText!,
                region: regionText!,
                street: streetText!,
                latitude: 12.123123,
                longitude: 12.123123),
            phoneNumber: phoneText!,
            email: emailText!));
        if (newPatient) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Success'),
                    content: const Text(
                        'You have successfully registered. Please sign in using your credentials.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ));
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const LoginScreen(),
                  type: PageTransitionType.rightToLeft));
        }
      }
    } catch (e) {
      setState(() {
        isLogin = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            )
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  // color: Colors.red,
                  child: Lottie.asset('assets/animations/patient.json'),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "User Registration Form",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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

                        //! Date of Birth
                        DatePicker(
                            dateOfBirth: dateOfBirth,
                            updateValue: (value) {
                              setState(() {
                                dateOfBirth = value;
                              });
                            }),

                        //! Gender
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            label: const Text("Choose Gender*"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) =>
                              value == null ? 'Field must not be empty' : null,
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

                        //! Email
                        InputWidget(
                            controller: _email,
                            updateValue: (value) {
                              emailText = value;
                            },
                            hintText: "Email*",
                            validator: InputValidators.emailValidate),

                        //! Phone Number
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

                        //! Password
                        PasswordInput(
                            validator: InputValidators.passwordValidate,
                            confirmPassValidator: confirmPasswordValidate,
                            passController: _password,
                            confirmPassController: _confirmPassword,
                            updatePass: (value) {
                              passwordText = value;
                            },
                            updateConfirmPass: (value) {
                              confirmPasswordText = value;
                            })
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                isLogin == false
                    ? ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (dateOfBirth != null) {
                              _formKey.currentState!.save();
                              _registerPatient();
                              FocusScope.of(context).unfocus();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text(
                                            'Please select a date of birth'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      ));
                            }
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width * 0.9, 65)),
                        ),
                        child: const Text('Register'),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? confirmPasswordValidate(String? confirmPassword) {
    if (confirmPassword!.isEmpty) {
      return 'Please re-enter your password';
    } else if (confirmPassword != _password.text) {
      return "Password didn't match";
    } else {
      return null;
    }
  }
}
