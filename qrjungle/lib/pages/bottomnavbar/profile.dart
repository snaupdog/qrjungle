import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void initState() {
    super.initState();
    fetchUrls();
  }

  Future<void> fetchUrls() async {
    try {
      await Apiss().listCustomers();
    } catch (e) {
      print('Error: $e');
    }
  }

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
    return const Placeholder();
  }
}
