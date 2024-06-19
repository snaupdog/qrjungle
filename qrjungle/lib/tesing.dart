import 'package:flutter/material.dart';

class Teasoigm extends StatelessWidget {
  const Teasoigm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.black,
                Color(0xff36ABA6),
              ],
            ),
          ),
          width: 500,
          height: 600,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 20.0), // Adjust padding
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      'assets/my_image.png',
                      fit: BoxFit.cover, // Ensure the image covers the area
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  "Cost : -100\$\$",
                  style: TextStyle(color: Colors.white, fontSize: 45.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
