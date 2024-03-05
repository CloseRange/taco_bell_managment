// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taco_bell_managment/page/account_setup/create_account_screen.dart';
import 'package:taco_bell_managment/util/ui_widgets.dart';
import 'package:taco_bell_managment/util/style_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();

}

class _LoginState extends State<StatefulWidget> {
  var inputGroup = InputGroup(["Username", "Password"]);

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
                  Text("Login",
                      style: TextStyle(
                        fontSize: 36,
                        color: Palette.getCore().text,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 10),
                  Text("Welcome Back", style: TextStyle(fontSize: 24, color: Palette.getCore().text)),
              
                  SizedBox(height: 30),
                  inputGroup.field(context, "Username"),
                  SizedBox(height: 10),
                  inputGroup.field(context, "Password", obscure: true),
                  SizedBox(height: 10),
                  EmphesizedButton("Sign In", callback: () => print("Okkk")),
                  SizedBox(height: 25),
                  LinkMessage("Don't have an account?", "Create Account", () => onCreateAccount(context)),
                ],
              ),
            ),
          ),
        )),
      );
  void onCreateAccount(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const CreateAccountScreen())
    );
  }
}
