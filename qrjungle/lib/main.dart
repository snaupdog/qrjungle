// ignore_for_file: avoid_print, dead_code_catch_following_catch

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/amplifyconfig.dart';
import 'myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Config());
}

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  AmplifyAuthCognito? auth;

  @override
  void initState() {
    _configureAmplify();
    super.initState();
  }

  void _configureAmplify() async {
    print("*****************");
    if (!mounted) return;
    auth = AmplifyAuthCognito();
    await Amplify.addPlugins([auth as AmplifyAuthCognito, AmplifyAPI()]);
    try {
      await Amplify.configure(amplifyconfig);

      print('Configured Done!!');
    } on AmplifyAlreadyConfiguredException {
      print('Already Configured!!');
    }
    try {} catch (e) {
      print('error in _configureAmplify:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}
