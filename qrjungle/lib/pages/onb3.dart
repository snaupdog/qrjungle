import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/main.dart';

import 'buttons.dart';
import 'package:qrjungle/themes.dart';

class Onb3 extends StatefulWidget {
  const Onb3({super.key});

  @override
  State<Onb3> createState() => _Onb3State();
}

class _Onb3State extends State<Onb3> {

  final int _currentPageIndex = 2;

  @override
  Widget build(BuildContext context) {
    late bool whatisbrightness;
    if (themeselector.thememode == ThemeMode.light) {
      whatisbrightness = true;
    } else {
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
              child: Image.asset('assets/$bgimage', fit: BoxFit.fitHeight)
            ),
            Positioned(
              top: 140,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedWidget(
                  delayDuration: Duration(milliseconds: 200),
                  animationDuration: Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Plain QRs are so 2010...',
                        style: TextStyle(
                          color: whatisbrightness ? secondarycolor : primarycolor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DelayedWidget(
                  delayDuration: Duration(milliseconds: 200),
                  animationDuration: Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Browse through our extensive selection of QR codes, we got what you need!",
                        style: TextStyle(
                          color: whatisbrightness ? secondarycolor : primarycolor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],                  
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height*0.08,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Image.asset('assets/qrstack.gif')
            ),
          ],
        ),
      floatingActionButton: Buttons(currentPageindex: _currentPageIndex),
    );
  }
}