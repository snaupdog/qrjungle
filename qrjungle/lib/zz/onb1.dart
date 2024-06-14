import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/buttons.dart';
import 'package:qrjungle/themes.dart';

import 'main.dart';


class Onb1 extends StatefulWidget {
  const Onb1({super.key});

  @override
  State<Onb1> createState() => _Onb1State();
}

class _Onb1State extends State<Onb1> {

  final int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    late bool whatisbrightness;
    if (themeselector.thememode == ThemeMode.light) {
      whatisbrightness = true;
    }
    else{
      whatisbrightness = false;
    }
    String bgimage = whatisbrightness ? 'onboardbg_light.png' : 'onboardbg.png';
    return Scaffold(
      body: 
            Stack(              
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset('assets/$bgimage', fit: BoxFit.fitHeight)),
                Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: DelayedWidget(
                        delayDuration: Duration(milliseconds: 200),
                        animationDuration: Duration(seconds: 1),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: Text(
                          'Welcome to QRJungle!',
                          style: TextStyle(
                            color: whatisbrightness ? secondarycolor : primarycolor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: DelayedWidget(
                        delayDuration: Duration(milliseconds: 1000),
                        animationDuration: Duration(seconds: 1),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: Text(
                          "We're glad to have you here!",
                          style: TextStyle(
                            color: whatisbrightness ? secondarycolor : primarycolor,
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