import 'package:blur_bottom_bar/blur_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/pages/bottomnavbar/explore.dart';
import 'package:qrjungle/themes.dart';
import 'pages/bottomnavbar/profile.dart';
import 'pages/bottomnavbar/wishlist.dart';

class PageSelect extends StatefulWidget {
  final int initialIndex;
  const PageSelect({super.key, this.initialIndex = 0});

  @override
  State<PageSelect> createState() => _PageSelectState();
}

class _PageSelectState extends State<PageSelect> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

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
    Brightness brightness = Theme.of(context).brightness;
    Color colorcolor = brightness == Brightness.dark
        ? const Color.fromARGB(255, 10, 10, 10).withOpacity(0.95)
        : primarycolor.withOpacity(0.95);
    Color alternatecolor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('qrjungle'),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: const [
                ExplorePage(), // Widget Layout for Explore Page
                WishlistPage(), // Widget Layout for Wishlist Page
                ProfilePage(), // Widget Layout for Profile Page
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlurBottomView(
              onIndexChange: onItemTapped,
              selectedItemColor: accentcolor,
              unselectedItemColor: alternatecolor,
              backgroundColor: colorcolor,
              currentIndex: _currentIndex,
              bottomNavigationBarItems: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code), label: 'Explore'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outlined), label: 'Favourites'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
