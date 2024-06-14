import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/main.dart';

import 'buttons.dart';
import 'themes.dart';

class Onb2 extends StatefulWidget {
  const Onb2({super.key});

  @override
  State<Onb2> createState() => _Onb2State();
}

class _Onb2State extends State<Onb2> {
  final int _currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    late bool whatisbrightness;
    if (themeselector.thememode == ThemeMode.light) {
      whatisbrightness = true;
    } else {
      whatisbrightness = false;
    }
    String bgimage = whatisbrightness ? 'onboardbg_light.png' : 'onboardbg.png';
    String qrimage = whatisbrightness ? 'plainqr_invert.png' : 'plainqr.png';
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset('assets/$bgimage', fit: BoxFit.fitHeight)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DelayedWidget(
                  delayDuration: Duration(milliseconds: 200),
                  animationDuration: Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Center(
                      child: Image.asset('assets/$qrimage', height: 230))),
              Center(
                child: DelayedWidget(
                  delayDuration: Duration(milliseconds: 1000),
                  animationDuration: Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                    child: Text(
                      "Say goodbye to boring old QRs!",
                      style: TextStyle(
                        color: whatisbrightness ? secondarycolor : primarycolor,
                        fontSize: 22,
                      ),
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
