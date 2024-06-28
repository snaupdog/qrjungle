import 'package:flutter/material.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQRsPage extends StatefulWidget {
  const MyQRsPage({super.key});

  @override
  State<MyQRsPage> createState() => _MyQRsPageState();
}

class _MyQRsPageState extends State<MyQRsPage> {

  getloginstatus() async {
    print('******* LOGINSTATUS CALLED *********8');
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool loggedin = pref.getBool('loggedin') ?? false;
    print("loggedin from sp: $loggedin");
    setState(() {
      loggedinmain = loggedin;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [                 
              const Center(
                child: Text(
                  'My QRs',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              (!loggedinmain)
                  ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height*0.2),
                Image.asset('assets/empty.png', height: 200),
                SizedBox(height: 15),
                Text('Not Logged In :(', style: TextStyle(fontSize: 40)),
              ],
            ) 
                  : Container(
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      width: MediaQuery.sizeOf(context).width,
                      child: const Qrcardgrid(type: "myqrs", categoryName: "")),
            ],
          ),
        ),
      ),
    );
  }
}




// (qrlisty.isEmpty)
//             ? (!loggedinmain) 
//             ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: MediaQuery.sizeOf(context).height*0.2),
//                 Image.asset('assets/empty.png', height: 200),
//                 SizedBox(height: 15),
//                 Text('Not Logged In :(', style: TextStyle(fontSize: 40)),
//               ],
//             ) 
//             : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: MediaQuery.sizeOf(context).height*0.2),
//                 Image.asset('assets/empty.png', height: 200),
//                 SizedBox(height: 15),
//                 Text('Empty :(', style: TextStyle(fontSize: 40)),
//               ],
//             )