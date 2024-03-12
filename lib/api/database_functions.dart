import 'package:taco_bell_managment/api/firebase_api.dart';

/// ***Database***
///
/// Static class for calling all generic database functions.
/// Preface this class with the `init` function and waiting for
/// `isReady` to make any function calls.
class Database {
  static bool _hasBeenInit = false;
  /// ***Init***
  /// 
  /// Initializes the database allowing for future database queries.
  /// 
  /// You can call this in 2 differant ways:
  /// ```dart
  /// main() async {
  ///   await Database.init(...);
  ///   // All api calls are now ready
  /// }
  /// ```
  /// This will ensure that firebase is working but will force the user to be conencted
  /// to the internet.
  ///
  /// Otherwise you can do this:
  /// ```dart
  /// main() {
  ///   Database.init(...);
  ///   // Database not ready
  ///   if(Database.isReady) {
  ///     // test if database is ready
  ///   }
  /// }
  /// ```
  static Future<void> init({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
  }) async {
    if (_hasBeenInit) return;
    _hasBeenInit = true;

    await FirebaseApi.initialize(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId);

  }

  // void phoneVerifyAttemptVerify() {
  //   FirebaseApi.callFunction("callVerifyPhonenNumberCode", {
  //     "username": PhoneSetup.getUsername(),
  //     "code": inputGroup.get("Text Code"),
  //   }).then((status) => {inputGroup.setError("Text Code", false)});
  // }
}
