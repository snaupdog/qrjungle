import 'package:flutter/material.dart';
import 'package:qrjungle/themes.dart';
import 'wishlist.dart';
import 'settings.dart';
import 'profilee.dart';
import 'explore.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);

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
    TextTheme _textTheme = Theme.of(context).textTheme;
    Brightness _brightness = Theme.of(context).brightness;
    Color unselectedcolor = _brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text('qrjungle'),
      ),
      body: Container(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: [
            CartPage(), //Widget Layout for MyCart Page
            HomePage(), //Widget Layout for Home Page           
            ProfilePage(), //Widget Layout for MyProfile Page
            SettingsPage(), //Widget Layout for Settings Page
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          height: MediaQuery.sizeOf(context).height*0.09,
          child: SalomonBottomBar(
            itemPadding: EdgeInsets.all(17),
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.favorite_outline_sharp, size: 25),
                title: Text(
                  'Wishlist',
                  style: _textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
                selectedColor: Colors.red,
                unselectedColor: unselectedcolor,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.search, size: 25),
                title: Text(
                  'Explore',
                  style: _textTheme.bodySmall?.copyWith(color: Colors.green),
                ),
                selectedColor: Colors.green,
                unselectedColor: unselectedcolor,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.person, size: 25),
                title: Text(
                  'Profile',
                  style: _textTheme.bodySmall?.copyWith(color: accentcolor),
                ),
                selectedColor: accentcolor,
                unselectedColor: unselectedcolor,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.settings_rounded, size: 25),
                title: Text(
                  'Settings',
                  style: _textTheme.bodySmall?.copyWith(color: const Color.fromARGB(255, 94, 94, 94)),
                ),
                selectedColor: Color.fromARGB(255, 70, 70, 70),
                unselectedColor: unselectedcolor,
              ),
            ],
            currentIndex: _currentIndex,
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }
}