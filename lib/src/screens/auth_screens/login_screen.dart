import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/models/auth/login_request.dart';
import 'package:appointmed/src/repositories/auth_repository.dart';
import 'package:appointmed/src/screens/doctor_screens/doctor_home.dart';
import 'package:appointmed/src/screens/patient_screens/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:showcaseview/showcaseview.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();
  final storage = const FlutterSecureStorage();

  final _email = TextEditingController();
  final _password = TextEditingController();

  late String emailText, passwordText;

  late bool _isPasswordVisible;
  bool isLogin = false;

  void _signIn() async {
    try {
      setState(() {
        isLogin = true;
      });

      if (await _authRepository
          .signIn(LoginRequest(email: emailText, password: passwordText))) {
        Future.delayed(const Duration(seconds: 2), () async {
          var role = await storage.read(key: 'role');
          setState(() {
            if (role == 'Doctor') {
              Navigator.pushReplacement(
                context,
                PageTransition(
                    child: ShowCaseWidget(
                      builder:
                          Builder(builder: (context) => const DoctorHome()),
                    ),
                    type: PageTransitionType.rightToLeftWithFade),
              );
            } else if (role == 'Patient') {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: ShowCaseWidget(
                        builder:
                            Builder(builder: (context) => const PatientHome()),
                      ),
                      type: PageTransitionType.rightToLeftWithFade));
            }
          });
        });
      }
    } catch (error) {
      setState(() {
        isLogin = false;
      });
      ErrorDialog.show(context: context, message: error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Lottie.asset('assets/animations/login.json'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //! Email Field
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: _email,
                          validator: emailValidate,
                          onSaved: (value) {
                            emailText = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //! Password Field
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: "Password",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(_isPasswordVisible != true
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          obscureText: !_isPasswordVisible,
                          obscuringCharacter: "\u2749",
                          textInputAction: TextInputAction.go,
                          controller: _password,
                          validator: passwordValidate,
                          onSaved: (value) {
                            passwordText = value!;
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
                            _signIn();
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text('Login'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width * 0.9, 65)),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? emailValidate(String? email) {
    if (email!.isEmpty) {
      return 'Field must not be empty';
    } else {
      return null;
    }
  }

  String? passwordValidate(String? password) {
    if (password!.isEmpty) {
      return 'Field must not be empty';
    } else {
      return null;
    }
  }
}
