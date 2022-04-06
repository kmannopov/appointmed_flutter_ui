import 'package:appointmed/src/screens/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({Key? key}) : super(key: key);

  @override
  _DoctorRegistrationScreenState createState() =>
      _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late bool _visiblePassword;
  late bool _visibleConfirmPassword;

  bool isLogin = false;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final String role = 'Doctor';

  String? firstNameText;
  String? lastNameText;
  DateTime? dateOfBirth;
  String? gender;
  String? emailText;
  String? phoneText;
  String? passwordText;
  String? confirmPasswordText;

  void _saveItem() async {
    try {
      setState(() {
        isLogin = true;
      });
      // final newUser = await _auth.createUserWithEmailAndPassword(
      //     email: emailText, password: passwordText);

      // _addDoctor(userID);

      // sendDoctor(userID);

      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const LoginScreen(),
              type: PageTransitionType.rightToLeft));
    } catch (e) {
      setState(() {
        isLogin = false;
      });
      print(e);

      String errorText = getMessageFromErrorCode(e);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorText),
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

  String getMessageFromErrorCode(error) {
    switch (error.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        isLogin = false;
        return "Email already used. Go to login page.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        isLogin = false;
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        isLogin = false;
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        isLogin = false;
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "too-many-requests":
        isLogin = false;
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        isLogin = false;
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        isLogin = false;
        return "Email address is invalid.";
      default:
        isLogin = false;
        return "Login failed. Please try again.";
    }
  }

  // void _addDoctor(String userID) {

  // }

  // sendDoctor(String userID) async {
  //   // final String url = 'https://bcrecapc.ml/api/doctor/';
  //   final String url = 'https://bcrecapc.ml/api/doctor/';
  //   try {
  //     var response = await http.post(Uri.parse(url), body: {
  //       "registration_id": userID,
  //       "doctor_registration_number": registrationNumberText,
  //       "doctor_name": nameText,
  //       "doctor_gender": _chosenValue,
  //       "mail_id": emailText,
  //       "phone_no": phoneText
  //     });
  //     if (response.statusCode == 201) {
  //       print(response.body);
  //     } else {
  //       print(response.statusCode);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _visiblePassword = false;
    _visibleConfirmPassword = false;
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
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: const Text("First Name*"),
                            alignLabelWithHint: true,
                          ),
                          textInputAction: TextInputAction.next,
                          controller: _firstName,
                          validator: nameValidate,
                          onSaved: (value) {
                            firstNameText = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //! Last Name
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: const Text("Last Name*"),
                            alignLabelWithHint: true,
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: _lastName,
                          validator: nameValidate,
                          onSaved: (value) {
                            lastNameText = value!;
                          },
                        ),

                        //! Date of Birth
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                child: const Text(
                                  "Date of Birth:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.all(5),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(dateOfBirth == null
                                          ? 'Please choose a date'
                                          : DateFormat.yMMMd()
                                              .format(dateOfBirth as DateTime)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _presentDatePicker,
                                    child: const Text(
                                      'Choose Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

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
                          value: gender,
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
                              gender = value!;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //! Email
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: const Text('Email*'),
                            alignLabelWithHint: true,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          validator: emailValidate,
                          onSaved: (value) {
                            emailText = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //! Phone Number
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: const Text("Phone Number*"),
                            alignLabelWithHint: true,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: _phone,
                          validator: phoneValidate,
                          onSaved: (value) {
                            phoneText = value!;
                          },
                        ),
                        const SizedBox(height: 20),

                        //! Password
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    label: const Text("Password*"),
                                    alignLabelWithHint: true,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _visiblePassword =
                                                !_visiblePassword;
                                          });
                                        },
                                        icon: Icon(_visiblePassword == true
                                            ? Icons.visibility
                                            : Icons.visibility_off))),
                                obscureText: !_visiblePassword,
                                obscuringCharacter: "\u2749",
                                textInputAction: TextInputAction.next,
                                controller: _password,
                                validator: passwordValidate,
                                onSaved: (value) {
                                  passwordText = value!;
                                },
                              ),
                            ),
                            const Spacer(),
                            const Tooltip(
                              message:
                                  '\n\u2022 Include both lowercase and uppercase characters\n\u2022 Include atleast one number\n\u2022 Include atleast one special character\n\u2022 Be at least 8 characters long\n',
                              triggerMode: TooltipTriggerMode.tap,
                              showDuration: Duration(seconds: 5),
                              preferBelow: false,
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //! Confirm Password
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: const Text("Confirm Password*"),
                              alignLabelWithHint: true,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _visibleConfirmPassword =
                                          !_visibleConfirmPassword;
                                    });
                                  },
                                  icon: Icon(_visibleConfirmPassword == true
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                          obscureText: !_visibleConfirmPassword,
                          textInputAction: TextInputAction.go,
                          obscuringCharacter: "\u2749",
                          controller: _confirmPassword,
                          validator: confirmPasswordValidate,
                          onSaved: (value) {
                            confirmPasswordText = value!;
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
                            _formKey.currentState!.save();
                            print(role);
                            print(firstNameText);
                            print(lastNameText);
                            print(emailText);
                            print(phoneText);
                            print(passwordText);
                            print(confirmPasswordText);

                            _saveItem();
                            FocusScope.of(context).unfocus();
                          }
                        },
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

  String? nameValidate(String? name) {
    if (name!.isEmpty) {
      return 'Field must not be empty';
    } else {
      return null;
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 80)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    ).then((value) {
      if (value == null) return;
      setState(() {
        dateOfBirth = value;
      });
    });
  }

  String? emailValidate(String? email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regEx = RegExp(pattern);

    if (email!.isEmpty) {
      return 'Field must not be empty';
    } else if (!regEx.hasMatch(email)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  String? phoneValidate(String? phone) {
    if (phone!.isEmpty) {
      return 'Field must not be empty';
    } else if (phone.length < 12 || phone.length > 12) {
      return 'Phone number should contain 12 digits';
    } else {
      return null;
    }
  }

  String? passwordValidate(String? password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regEx = RegExp(pattern);

    if (password!.isEmpty) {
      return 'Field must not be empty';
    } else if (!regEx.hasMatch(password)) {
      return "Choose a strong password";
    } else {
      return null;
    }
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
