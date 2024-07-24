import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'buttons.dart';

class Onb2 extends StatefulWidget {
  const Onb2({super.key});

  @override
  State<Onb2> createState() => _Onb2State();
}

class _Onb2State extends State<Onb2> {
  final int _currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    String bgimage = 'onboardbg.png';
    String qrimage = 'plainqr.png';
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
              DelayedWidget(
                  delayDuration: const Duration(milliseconds: 200),
                  animationDuration: const Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Center(
                      child: Image.asset('assets/$qrimage', height: 230))),
              Center(
                child: DelayedWidget(
                  delayDuration: const Duration(milliseconds: 1000),
                  animationDuration: const Duration(seconds: 1),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                    child: Text(
                      "Say goodbye to boring old QRs!",
                      style: TextStyle(
                        color: Colors.white,
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
