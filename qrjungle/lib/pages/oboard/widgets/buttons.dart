import 'package:flutter/material.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onb2.dart';
import 'onb3.dart';

class Buttons extends StatefulWidget {
  final int currentPageindex;
  const Buttons({super.key, required this.currentPageindex});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    late bool whatisbrightness;
    if (brightness == Brightness.light) {
      whatisbrightness = true;
    } else {
      whatisbrightness = false;
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (widget.currentPageindex == 0)
        Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.85),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Onb2()));
            },
            backgroundColor: whatisbrightness
                ? const Color.fromARGB(255, 218, 218, 218)
                : const Color.fromARGB(255, 31, 31, 31),
            elevation: 0,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      if (widget.currentPageindex == 1)
        Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.85),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Onb3()));
            },
            backgroundColor: whatisbrightness
                ? const Color.fromARGB(255, 218, 218, 218)
                : const Color.fromARGB(255, 31, 31, 31),
            elevation: 0,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      if (widget.currentPageindex == 2)
        Container(
          margin:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.084),
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: FloatingActionButton(
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              await pref.setBool('onboarded', true);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PageSelect()),
                (Route<dynamic> route) => false,
              );
            },
            backgroundColor: whatisbrightness
                ? const Color.fromARGB(255, 218, 218, 218)
                : const Color.fromARGB(255, 31, 31, 31),
            elevation: 0,
            child: Text(
              'Get Started!',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
    ]);
  }
}
