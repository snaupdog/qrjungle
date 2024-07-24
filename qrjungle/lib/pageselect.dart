import 'package:blur_bottom_bar/blur_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/pages/bottomnavbar/explore.dart';
import 'package:qrjungle/pages/bottomnavbar/myqrs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pages/bottomnavbar/profile.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PageSelect extends StatefulWidget {
  final int initialIndex;
  const PageSelect({super.key, this.initialIndex = 0});

  @override
  State<PageSelect> createState() => _PageSelectState();
}

class _PageSelectState extends State<PageSelect> {
  late int _currentIndex;
  late PageController _pageController;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
    final theme = Theme.of(context);

    String appBarTitle;

    switch (_currentIndex) {
      case 0:
        appBarTitle = 'qrjungle';
        break;
      case 1:
        appBarTitle = 'My QRs';
        break;
      case 4:
        appBarTitle = 'Profile';
        break;
      default:
        appBarTitle = '';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(
            fontSize: 30,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        actions: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  themeController.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: themeController.isDarkMode.value
                      ? Colors.yellow
                      : Colors.blue,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (value) {
                    themeController.toggleTheme();
                  },
                  activeColor: Colors.redAccent,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.qr_code_scanner_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRViewPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: const [
                ExplorePage(),
                MyQRsPage(),
                ProfilePage(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 300,
            child: BlurBottomView(
              onIndexChange: onItemTapped,
              selectedItemColor: theme.colorScheme.onPrimary,
              showSelectedLabels: true,
              unselectedItemColor: theme.colorScheme.tertiary,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              currentIndex: _currentIndex,
              bottomNavigationBarItems: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_mall_outlined),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code),
                  label: 'MyQRs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class QRViewPage extends StatefulWidget {
  const QRViewPage({super.key});

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('QR Scanner', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (_isScanning) return;
              setState(() {
                _isScanning = true;
              });

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
              Barcode code = barcodes[0];
              String codeUrl = code.rawValue ?? "---";
              final Uri url = Uri.parse(codeUrl);

              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                debugPrint('Could not launch $url');
              }

              setState(() {
                _isScanning = false;
              });
            },
          ),
          Center(child: Image.asset('assets/qrscan.png')),
        ],
      ),
    );
  }
}
