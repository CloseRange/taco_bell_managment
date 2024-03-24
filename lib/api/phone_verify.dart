import 'package:taco_bell_managment/api/firebase_api.dart';

/// ***Phone Verify***
///
/// Simple class that wraps around Database to help verify a phone number
class PhoneVerify {
  static var _username = "";
  static var _phonenumber = "";
  static var _phonenumberFull = "";
  static var _enabled = true;
  static var _error = "";

  /// Username to apply to
  static String get username => _username;

  /// Attempted phoenumber to text - Display number
  static String get phonenumber => _phonenumber;

  /// Attempted phoenumber to text - Full number
  static String get phonenumberFull => _phonenumberFull;

  /// Attempted phoenumber to text - Full number
  static String get phonenumberDisplay => _getPhoneNumberDisplay();

  /// If interactions should be diabled or not
  static bool get enabled => _enabled;

  /// The current error message
  static String get error => _error;

  /// If any erorr currently exists
  static bool get hasError => _error != "";

  static void setUsername(String username) {
    _username = username;
  }

  /// Returns the display version of a phone number +x(xxx) xxx-xxxx
  static String _getPhoneNumberDisplay() {
    try {
      var a = _phonenumberFull.substring(0, 2);
      var b = _phonenumberFull.substring(2, 5);
      var c = _phonenumberFull.substring(5, 8);
      var d = _phonenumberFull.substring(8, 12);
      return '$a ($b) $c-$d';
    } on Exception {
      return "";
    }
  }

  static void setPhonenumber(String phonenumber) {
    if (phonenumber.startsWith("+")) {
      _phonenumberFull = phonenumber;
      _phonenumber = _phonenumberFull.substring(2, _phonenumberFull.length - 2);
    } else {
      _phonenumberFull = "+1$phonenumber";
      _phonenumber = _phonenumberFull.substring(2, _phonenumberFull.length);
    }
  }

  static Future<dynamic> sendVerificationCode(String code) async {
    return FirebaseApi.callFunction("callVerifyPhoneNumberCode", {
      "username": "mike123",
      "code": code,
    });
  }
  static Future<dynamic> sendVerificationCodeResend() async {
    return FirebaseApi.callFunction("callSendNewCode", {
      "username": PhoneVerify.username,
      "phonenumber": PhoneVerify.phonenumberFull,
    });
  }
  static Future<dynamic> cancelAccountCreate() async {
    return FirebaseApi.callFunction("callCancelAccountCreate", {
      "username": PhoneVerify.username,
      "notifID": FirebaseApi.notificationToken,
    });
  }

  static Future<dynamic> attemptAccountCreate(
      String username, String password, String phonenumber) async {
    setUsername(username);
    setPhonenumber(phonenumber);
    return FirebaseApi.callFunction("callCreateAccountAttempt", {
      "username": PhoneVerify.username,
      "phonenumber": PhoneVerify.phonenumberFull,
      "password": password,
      "notifID": FirebaseApi.notificationToken,
    });
  }
}
