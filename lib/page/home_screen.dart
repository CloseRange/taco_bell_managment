// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taco_bell_managment/util/ui_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<StatefulWidget> {
  String name = "";
  String to = "";
  String message = "";
  var inputG = InputGroup([]);
  
  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(
        //   title: Text('Taco Bell Managment',
        //       style: TextStyle(
        //         color: Palette.textTint,
        //       )),
        //   centerTitle: true,
        //   backgroundColor: Palette.tint,
        // ),
        // body: Center(
        //     child: Column(
        //   children: [
        //     inputG.field("Name"),
        //     inputG.field("To"),
        //     inputG.field("Message"),
        //   ],
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // )),
        // backgroundColor: Palette.background,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     FirebaseApi.write("messages", payload: {
        //       "name": inputG.get("Name"),
        //       "to": inputG.get("To"),
        //       "message": inputG.get("Message"),
        //     });
        //   },
        //   backgroundColor: Palette.button,
        //   child: Text(
        //     "send",
        //     style: TextStyle(color: Palette.textTint),
        //   ),
        // ),
      );
}

// ignore: avoid_print
// void buttonOnPressed() => Palette.setRandom();
