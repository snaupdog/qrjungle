import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'buttons.dart';

class Onb1 extends StatefulWidget {
  const Onb1({super.key});

  @override
  State<Onb1> createState() => _Onb1State();
}

class _Onb1State extends State<Onb1> {
  final int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    String bgimage = 'onboardbg.png';
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset('assets/$bgimage', fit: BoxFit.fitHeight)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: DelayedWidget(
                  delayDuration: const Duration(milliseconds: 200),
                  animationDuration: const Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: const Text(
                    'Welcome to QRJungle!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: DelayedWidget(
                  delayDuration: const Duration(milliseconds: 1000),
                  animationDuration: const Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: const Text(
                    "We're glad to have you here!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Buttons(currentPageindex: _currentPageIndex),
    );
  }
}
