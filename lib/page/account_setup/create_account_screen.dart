// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taco_bell_managment/api/firebase_api.dart';
import 'package:taco_bell_managment/page/account_setup/verify_phone_screen.dart';
import 'package:taco_bell_managment/util/phone_setup.dart';
import 'package:taco_bell_managment/util/ui_widgets.dart';
import 'package:taco_bell_managment/util/style_sheet.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<StatefulWidget> {
  var inputGroup = InputGroup(["Phone Number", "Username", "Password", "Retype Password"]);
  String errorMessage = "";

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
                      callback: () => FirebaseApi.callFirebase("callVerifyPhonenumber", {
                            "username": inputGroup.get("Username"),
                            "phonenumber": phoneNumberConversion(),
                            "password": inputGroup.get("Password"),
                            "notifID": FirebaseApi.token,
                          }).then((response) =>
                              onCreateResponse(context, response))),
                  SizedBox(height: 15),
                  LinkMessage("Already have an account?", "Login",
                      () => onLogin(context)),
                ],
              ),
            ),
          ),
        )),
      );
  void onLogin(BuildContext context) async {
    Navigator.pop(context);
  }

  void onVerifyPhone(BuildContext context) async {
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => const VerifyPhoneScreen()));
  }

  String phoneNumberConversion() {
    PhoneSetup.setPhone(inputGroup.get("Phone Number"));
    return PhoneSetup.getFullPhoneNumber();
  }

  void onCreateResponse(BuildContext context, dynamic response) {
    // print(response);
    setState(() {
      if (response["error"] != "") {
        errorMessage = response["error"];
      } else {
        PhoneSetup.setUsername(inputGroup.get("Username"));
        onVerifyPhone(context);
      }
    });
  }
}
