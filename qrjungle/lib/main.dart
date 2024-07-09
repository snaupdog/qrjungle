import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qrjungle/amplifyconfig.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/moreqr/widgets/iap_services.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:qrjungle/themeselector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/oboard/onboard.dart';
import 'themes.dart';

final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
final formkey = GlobalKey<FormState>();
ThemeSelect themeselector = ThemeSelect();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final onboarded = pref.getBool('onboarded') ?? false;
  runApp(Config(onboarded: onboarded));
}

class Config extends StatefulWidget {
  final bool onboarded;
  const Config({required this.onboarded, super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  AmplifyAuthCognito? auth;
  late StreamSubscription<List<PurchaseDetails>> _iapSubscription;

  @override
  void initState() {
    _configureAmplify();
    themeselector.addListener(themeListener);
    getValues();
    super.initState();

    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _iapSubscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("Purchase stream started");
      IAPService().listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _iapSubscription.cancel();
    }, onError: (error) {
      _iapSubscription.cancel();
    }) as StreamSubscription<List<PurchaseDetails>>;
  }

  void _configureAmplify() async {
    print("*****************");
    if (!mounted) return;
    auth = AmplifyAuthCognito();
    await Amplify.addPlugins([auth as AmplifyAuthCognito, AmplifyAPI()]);
    try {
      await Amplify.configure(amplifyconfig);
      print('Configured Done!!');
      getloginstatus();
    } on AmplifyAlreadyConfiguredException {
      print('Already Configured!!');
    }
    try {} catch (e) {
      print('error in _configureAmplify:$e');
    }
  }

  @override
  void dispose() {
    themeselector.removeListener(themeListener);
    super.dispose();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  bool onboarded = false;

  getValues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool onb = pref.getBool('onboarded') ?? false;

    Apiss().getAllqrs("");
    Apiss().getCategories();
    setState(() {
      onboarded = onb;
    });
  }

  getUserdata() async {
    Apiss().listUserDetails();
    Apiss().listFavourites();
    Apiss().listmyqrs();
  }

  getloginstatus() async {
    print('******* LOGINSTATUS CALLED *********8');
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool loggedin = pref.getBool('loggedin') ?? false;
    print("loggedin from sp: $loggedin");
    setState(() {
      loggedinmain = loggedin;
    });
    if (loggedinmain) {
      getUserdata();
    }
  }

  @override
  Widget build(BuildContext context) {
    late bool whatisbrightness;
    if (themeselector.thememode == ThemeMode.light) {
      whatisbrightness = true;
    } else {
      whatisbrightness = false;
    }
    String splashimage = whatisbrightness ? 'logo_invert.png' : 'logo.png';
    Color splashbg = whatisbrightness ? primarycolor : secondarycolor;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeselector.thememode,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/$splashimage'),
        splashIconSize: 200,
        backgroundColor: splashbg,
        nextScreen: (widget.onboarded)
            ? const PageSelect(
                initialIndex: 0,
              )
            : Onboard(),
        animationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
