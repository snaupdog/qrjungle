import 'dart:ui';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/pages/qrcards/qr_card.dart';
import 'package:qrjungle/themes.dart';

import 'pages/bottomnavbar/profile.dart';
import 'pages/bottomnavbar/wishlist.dart';

class PageSelect extends StatefulWidget {
  const PageSelect({super.key});

  @override
  State<PageSelect> createState() => _PageSelectState();
}

class _PageSelectState extends State<PageSelect> {

  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    //TextTheme _textTheme = Theme.of(context).textTheme;
    Brightness _brightness = Theme.of(context).brightness;
    //Color colorcolor = _brightness == Brightness.dark ? Colors.black : Colors.white;
    Color alternatecolor = _brightness == Brightness.dark ? Colors.white : Colors.black;

    final iconList = <IconData> [
      Icons.qr_code,
      Icons.favorite_rounded,
      Icons.person,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('qrjungle'),
      ),
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: [
              qrCards(), //Widget Layout for Explore Page        
              WishlistPage(), //Widget Layout for Wishlist Page   
              ProfilePage(), //Widget Layout for Profile Page
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Color.fromARGB(225, 42, 42, 42).withOpacity(0.00001),
                  child: AnimatedBottomNavigationBar(                    
                    backgroundColor: Colors.transparent,
                    activeColor: accentcolor,
                    inactiveColor: alternatecolor,
                    iconSize: 30,
                    splashSpeedInMilliseconds: 350,
                    icons: iconList,
                    activeIndex: _currentIndex,
                    onTap: onItemTapped,                  
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}