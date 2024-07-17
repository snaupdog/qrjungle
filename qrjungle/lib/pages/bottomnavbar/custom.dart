import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/pages/customform.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  final List<String> images = [
    'assets/qr1.png',
    'assets/qr2.png',
    'assets/qr3.png',
    'assets/qr4.png',
    'assets/qr5.png',
  ];

  final List<String> imageTexts = [
    'Restaurant Menus',
    'Google Reviews',
    'Information Redirects',
    'Quick Links',
    'Social Media Links'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(15),
              ),
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 20, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Want your customisation on our QRs?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomForm()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: Center(
                                  child: Text('Get Started!',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.white),
                                ),
                                backgroundColor: Colors.transparent,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Image.asset('assets/qrsqrs.png', height: 160))
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Use custom QRs for: '),            
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 255, 255, 255),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Swiper(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        images[index],
                        fit: BoxFit.contain,
                        height: 200,
                      ),
                      SizedBox(height: 10),
                      Text(
                        imageTexts[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255), ),
                      ),
                    ],
                  );
                },
                autoplay: true,
                loop: true,
                viewportFraction: 0.4,
                scale: 0.4,
                layout: SwiperLayout.DEFAULT,
                itemHeight: 250,
                itemWidth: 250,
                pagination: SwiperPagination(
                  builder: RectSwiperPaginationBuilder(
                    activeColor: Colors.cyan,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
