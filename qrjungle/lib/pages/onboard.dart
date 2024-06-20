import 'package:flutter/material.dart';
import 'buttons.dart';
import 'onb1.dart';

class Onboard extends StatefulWidget {
  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onb1(),
      floatingActionButton: Buttons(currentPageindex: _currentPageIndex),
    );
  }
}