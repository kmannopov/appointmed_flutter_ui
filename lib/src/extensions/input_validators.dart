class InputValidators {
  static String? textValidate(String? text) {
    if (text!.isEmpty) {
      return 'Field must not be empty';
    } else {
      return null;
    }
  }

  static String? emailValidate(String? email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regEx = RegExp(pattern);

    if (email!.isEmpty) {
      return 'Please enter your email';
    } else if (!regEx.hasMatch(email)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  static String? phoneValidate(String? phone) {
    if (phone!.isEmpty) {
      return 'Please enter your phone number';
    } else if (phone.length < 12 || phone.length > 12) {
      return 'Phone number should contain 12 digits';
    } else {
      return null;
    }
  }

  static String? passwordValidate(String? password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regEx = RegExp(pattern);

    if (password!.isEmpty) {
      return 'Please enter a password';
    } else if (!regEx.hasMatch(password)) {
      return "Choose a strong password";
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidate(
      String? password, String? confirmPassword) {
    if (confirmPassword!.isEmpty) {
      return 'Please re-enter your password';
    } else if (confirmPassword != password) {
      return "Password didn't match";
    } else {
      return null;
    }
  }
}
