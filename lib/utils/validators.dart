class Validators {
  static bool isEmail(String s) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(s);
  }

  static bool isPhone(String s) {
    return RegExp(r'^[0-9]{7,15}$').hasMatch(s);
  }

  static bool isEmailOrPhone(String s) {
    s = s.trim();
    return isEmail(s) || isPhone(s);
  }

  static String? nonEmpty(String s) {
    if (s.trim().isEmpty) return 'Required';
    return null;
  }

  static bool validPassword(String s) {
    return s.length >= 6; // adjust rules as needed
  }
}
