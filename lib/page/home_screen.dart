// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:taco_bell_managment/page/screens/screen_test.dart';
import 'package:taco_bell_managment/page/screens/screen_test2.dart';
import 'package:taco_bell_managment/page/screens/screen_test3.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<StatefulWidget> {
  var _currentIndex = 0;
  final _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_rounded, color: Colors.black),
      label: "Chat",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.schedule_rounded, color: Colors.black),
      label: "Schedule",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, color: Colors.black),
      label: "Employees",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.task_rounded, color: Colors.black),
      label: "Tasks",
    ),
  ];
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: 1),
        children: [
          ScreenTest3(),
          Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              children: [
                ScreenTest1(),
                ScreenTest2(),
                ScreenTest1(),
                ScreenTest2(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _bottomNavigationBarItems,
              currentIndex: _currentIndex,
              onTap: (value) {
                _pageController.animateToPage(value,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: avoid_print
// void buttonOnPressed() => Palette.setRandom();
