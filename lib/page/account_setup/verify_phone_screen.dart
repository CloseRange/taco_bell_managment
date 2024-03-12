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
  bool enableButtons = true;

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
                SizedBox(height: 10),
                inputGroup.field(context, "Text Code"),
                SizedBox(height: 10),
                EmphesizedButton("Submit",
                    callback: () => 
                      PhoneVerify.sendVerificationCode(inputGroup.get("Text Code")),
                    enabled: true,),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: (){}, 
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0), backgroundColor: Colors.red),
                  icon: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 5,
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                    ),
                  ),
                  label: const Text("Testing"),
                ),
                LinkMessage("Didn't recieve code?", "Resend Code",
                    () => _attemptResendPhoneNumber(),
                    enabled: true,),
              ],
            ),
          ),
        ),
      )));
  // void onCreateResponse(BuildContext context, dynamic response) {
  //   print(response);
  // }

  // Future<dynamic> _attemptVerifyPhoneNumber() {
  //   return FirebaseApi.callFunction("callVerifyPhonenNumberCode", {
  //     "username": PhoneSetup.getUsername(),
  //     "code": inputGroup.get("Text Code"),
  //   }).then((status) => {inputGroup.setError("Text Code", false)});
  // }

  void _attemptResendPhoneNumber() {
    inputGroup.setError("Text Code", true);
    setState(() {
      
    });
    // return FirebaseApi.callFirebase("callSendNewCode", {
    //   "username": PhoneSetup.getUsername(),
    //   "phonenumber": PhoneSetup.getFullPhoneNumber(),
    // }).then((status) => {inputGroup.setError("Text Code", false)});
  }
}
