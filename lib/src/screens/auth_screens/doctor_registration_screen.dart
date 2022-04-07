import 'package:appointmed/src/extensions/input_validators.dart';
import 'package:appointmed/src/models/auth/register_request.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:appointmed/src/repositories/auth_repository.dart';
import 'package:appointmed/src/repositories/doctor_repository.dart';
import 'package:appointmed/src/screens/auth_screens/login_screen.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/date_picker.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/input_widget.dart';
import 'package:appointmed/src/screens/auth_screens/widgets/password_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({Key? key}) : super(key: key);

  @override
  _DoctorRegistrationScreenState createState() =>
      _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();
  final _doctorRepository = DoctorRepository();
  bool isLogin = false;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final String role = 'Doctor';

  String? firstNameText,
      lastNameText,
      genderText,
      emailText,
      phoneText,
      passwordText,
      confirmPasswordText;
  DateTime? dateOfBirth;

  void _registerDoctor() async {
    try {
      setState(() {
        isLogin = true;
      });

      var result = await _authRepository.register(RegisterRequest(
          email: emailText!, password: passwordText!, role: role));

      if (result) {
        var newDoctor = await _doctorRepository.registerDoctor(Doctor(
            firstName: firstNameText!,
            lastName: lastNameText!,
            dateOfBirth: dateOfBirth!,
            gender: genderText!,
            phoneNumber: phoneText!,
            email: emailText!));
        if (newDoctor) {
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
                  child: Lottie.asset('assets/animations/doctor.json'),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Doctor Registration Form",
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
                          },
                        ),
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
                              _registerDoctor();
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
      return 'Field must not be empty';
    } else if (confirmPassword != _password.text) {
      return "Password didn't match";
    } else {
      return null;
    }
  }
}
