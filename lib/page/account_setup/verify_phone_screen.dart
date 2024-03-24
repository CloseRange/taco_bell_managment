// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_print

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:taco_bell_managment/api/phone_verify.dart';
import 'package:taco_bell_managment/util/ui_widgets.dart';
import 'package:taco_bell_managment/util/style_sheet.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<StatefulWidget> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<StatefulWidget> {
  var inputGroup = InputGroup(["Text Code"]);
  String errorMessage = "";
  bool waitingForResponse = false;

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Palette.getCore().main,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Verify Phone",
                    style: TextStyle(
                      fontSize: 36,
                      color: Palette.getCore().text,
                      fontWeight: FontWeight.bold,
                    )),
                Text("Enter Code Below",
                    style: TextStyle(
                      fontSize: 20,
                      color: Palette.getCore().text,
                    )),
                // SizedBox(height: 10),
                SizedBox(height: 30),
                LinkMessage(
                    "Code sent to", PhoneVerify.phonenumberDisplay, () {},
                    color: Palette.getLink().darkText),
                LinkMessage(
                  "Click here to",
                  "cancel",
                  () => _cacelPhoneVerify(),
                  enabled: true,
                ),
                SizedBox(height: 10),
                inputGroup.field(context, "Text Code"),
                SizedBox(height: 10),
                EmphesizedButton(
                  "Submit",
                  callback: _attemptVerifyPhoneNumber,
                  loading: waitingForResponse,
                ),
                SizedBox(height: 15),
                // EventPage.getActionButton(this),
                LinkMessage(
                  "Didn't recieve code?",
                  "Resend Code",
                  _attemptResendPhoneNumber,
                  enabled: !waitingForResponse,
                ),
              ],
            ),
          ),
        ),
      )));
  // void onCreateResponse(BuildContext context, dynamic response) {
  //   print(response);
  // }

  void _attemptVerifyPhoneNumber() {
    setState(() {
      waitingForResponse = true;
    });
    PhoneVerify.sendVerificationCode(inputGroup.get("Text Code"))
        .then((status) {
      waitingForResponse = false;
      if (status) {
        // TODO: Login
      } else {
        inputGroup.clearField("Text Code");
        inputGroup.setError("Text Code", true);
      }
      setState(() {});
    });
  }

  void _attemptResendPhoneNumber() {
    waitingForResponse = true;
    setState(() {});
    PhoneVerify.sendVerificationCodeResend().then((status) {
      waitingForResponse = false;
      setState(() {
        errorMessage = status["error"];
      });
    });
  }

  void _cacelPhoneVerify() {
    // inputGroup.setError("Text Code", true);
    PhoneVerify.cancelAccountCreate();
    Navigator.pop(context);
  }
}
