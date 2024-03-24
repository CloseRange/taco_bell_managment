// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taco_bell_managment/api/phone_verify.dart';
import 'package:taco_bell_managment/page/account_setup/verify_phone_screen.dart';
import 'package:taco_bell_managment/util/ui_widgets.dart';
import 'package:taco_bell_managment/util/style_sheet.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateAccountState();
}

/// Represents the state of the CreateAccountScreen widget.
///
/// This class extends the [State] class and is responsible for managing the state
/// of the CreateAccountScreen widget. It contains methods and properties that
/// define the behavior and appearance of the widget.
class _CreateAccountState extends State<StatefulWidget> {
  var inputGroup =
      InputGroup(["Phone Number", "Username", "Password", "Retype Password"]);
  String errorMessage = "";
  bool waitingForResponse = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(
        //   title: Text('Taco Bell Managment',
        //       style: TextStyle(
        //         color: Palette.getTextTint(),
        //       )),
        //   centerTitle: true,
        //   backgroundColor: Palette.getTint(),
        // ),
        backgroundColor: Palette.getCore().main,
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create Account",
                      style: TextStyle(
                        fontSize: 36,
                        color: Palette.getCore().text,
                        fontWeight: FontWeight.bold,
                      )),
                  Text("Add Info Below",
                      style: TextStyle(
                        fontSize: 20,
                        color: Palette.getCore().text,
                      )),
                  // SizedBox(height: 10),
                  SizedBox(height: 30),
                  Text(errorMessage,
                      style: TextStyle(
                          color: Color.fromARGB(255, 243, 16, 0),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  inputGroup.field(context, "Phone Number", isNumber: true),
                  SizedBox(height: 10),
                  inputGroup.field(context, "Username"),
                  SizedBox(height: 10),
                  inputGroup.field(context, "Password", obscure: true),
                  SizedBox(height: 10),
                  inputGroup.field(context, "Retype Password", obscure: true),
                  SizedBox(height: 10),
                  EmphesizedButton(
                    "Create Account",
                    callback: () => {onCreateAccountResponse(context)},
                    loading: waitingForResponse,
                  ),
                  SizedBox(height: 15),
                  LinkMessage("Already have an account?", "Login",
                      () => Navigator.pop(context)),
                ],
              ),
            ),
          ),
        )),
      );

  /// Handles the response when creating an account.
  ///
  /// This method is called when the user completes the account creation process.
  /// It takes a [BuildContext] as a parameter, which is used to navigate to the
  /// next screen or perform any other necessary actions.
  void onCreateAccountResponse(BuildContext context) {
    // print(response);

    waitingForResponse = true;
    String pass2 = inputGroup.get("Retype Password");
    if (pass2 != inputGroup.get("Password")) {
      setState(() {
        errorMessage = "Passwords do not match";
        waitingForResponse = false;
      });
      return;
    }
    setState(() {});
    PhoneVerify.attemptAccountCreate(inputGroup.get("Username"),
            inputGroup.get("Password"), inputGroup.get("Phone Number"))
        .then((response) => {
              setState(() {
                waitingForResponse = false;
                if (response["error"] != "") {
                  errorMessage = response["error"];
                } else {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const VerifyPhoneScreen()));
                }
              })
            });
  }
}
