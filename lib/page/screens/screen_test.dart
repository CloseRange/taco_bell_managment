// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

// import 'dart:html';

import 'package:flutter/material.dart';

class ScreenTest1 extends StatefulWidget {
  const ScreenTest1({super.key});

  @override
  State<StatefulWidget> createState() => _ScreenTest1();
}

class _ScreenTest1 extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) { 
    return Container(color: Colors.blueAccent);
  }
}
