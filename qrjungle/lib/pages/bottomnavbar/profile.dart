import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    getuserdetailsmethod();
    super.initState();
  }
  getuserdetailsmethod ()async {
    await Apiss().getcurrentuserdetails();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Profile Page Here!'),
    );
  }
}