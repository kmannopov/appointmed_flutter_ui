import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  late String emailText;
  late String passwordText;

  late bool _isPasswordVisible;
  bool isLogin = false;

  void _signIn() async {
    try {
      setState(() {
        isLogin = true;
      });

      setState(() {
        // if (snapshot.value['role'] == 'Doctor') {
        //   setDoctorDetails(userId);
        //   Navigator.pushReplacement(
        //     context,
        //     PageTransition(
        //         child: ShowCaseWidget(
        //           builder: Builder(builder: (context) => DoctorScreen()),
        //         ),
        //         type: PageTransitionType.rightToLeftWithFade),
        //   );
        // } else if (snapshot.value['role'] == 'User') {
        //   setUserDetails(userId);
        //   Navigator.pushReplacement(
        //       context,
        //       PageTransition(
        //           child: ShowCaseWidget(
        //             builder: Builder(builder: (context) => UserHome(userId)),
        //           ),
        //           type: PageTransitionType.rightToLeftWithFade));
        // }
      });
      // print(userId);
    } catch (error) {
      setState(() {
        isLogin = false;
      });
      print(error);

      String errorText = getMessageFromErrorCode(error);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(errorText),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
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

  setDoctorDetails(String doctorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', 'Doctor');
    prefs.setString('doctorId', doctorId);
  }

  setUserDetails(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', 'User');
    prefs.setString('userId', userId);
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
          // color: Colors.red,
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
                          print(emailText);
                          print(passwordText);

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
