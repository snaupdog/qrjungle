import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/moreqr/moreqr.dart';
import 'package:qrjungle/pages/moreqr/viewmyqr.dart';
import 'package:qrjungle/pages/moreqr/widgets/modals.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Qrcardgrid extends StatefulWidget {
  final String type;
  final String categoryName;
  const Qrcardgrid({super.key, required this.type, required this.categoryName});

  @override
  State<Qrcardgrid> createState() => _QrcardgridState();
}

class MyClass {
  Map<String, dynamic> hi = {
    "qr_code_status": "fake",
    "qr_code_created_on": 1714738115822,
    "qr_code_image_url_key": "2Omp.png",
    "qr_code_id": "fake",
    "qr_prompt": "fake",
    "price": null
  };
  late List<Map<String, dynamic>> fakedata;

  MyClass() {
    fakedata = List.filled(10, hi);
  }
}

class _QrcardgridState extends State<Qrcardgrid> {
  late List<Map<String, dynamic>> fakedata;
  @override
  void initState() {
    fakedata = MyClass().fakedata;
    print(fakedata[0]['qr_code_id']);
    super.initState();
    fetchmyqrs();
  }

  TextEditingController emailController = TextEditingController();
  var qrlisty = [];
  bool inmyqrs = false;
  bool isloading = true;

  void LogInModalSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LoginModalSheet();
      },
    );
  }

  Future<String> signInCustomFlow(String username) async {
    print('email is: $username');
    await Amplify.Auth.signOut();
    // ignore: unused_local_variable
    final num = emailController.text;
    try {
      final result = await Amplify.Auth.signIn(username: username);
      print('Result@@@@@@@@@@@!!!!!!: $result');
      return 'Success';
    } on AuthException catch (e) {
      print("error");
      print("message: ${e.message}");
      if (e.message.contains('No password was provided')) {
        await Apiss().signup(emailController.text);
      }
      return e.message;
    }
  }

  Future<void> fetchmyqrs() async {
    print("\n\n\n\n\n\n\n\n");
    // await Apiss().clearlist()
    switch (widget.type) {
      case 'all':
        await Apiss().getAllqrs("");
        setState(() {
          qrlisty = Apiss.myallqrslist;
          isloading = false;
        });
        break;
      case 'categories':
        await Apiss().getqrfromCategories(widget.categoryName);
        setState(() {
          qrlisty = Apiss.mycatlist;
          isloading = false;
        });
        break;

      case 'wishlist':
        await Apiss().listFavourites();
        setState(() {
          qrlisty = Apiss.myfavslist;
          isloading = false;
        });
        break;

      case 'myqrs':
        await Apiss().listmyqrs();
        setState(() {
          qrlisty = Apiss.myqrslist;
          inmyqrs = true;
          isloading = false;
        });
        break;
      default:
        print("Defailt");
    }
  }

  getimage(String item) async {
    final hi = await Apiss().getPresignedUrl(item);
    return hi;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: isloading ? qrcard(fakedata) : qrcard(qrlisty),
      ),
    );
  }

  Skeletonizer qrcard(List<dynamic> data) {
    return Skeletonizer(
      enabled: isloading,
      enableSwitchAnimation: true,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 7.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 2 / 3),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final imageurl = data[index]['qr_code_image_url_key'];
          final item = data[index];
          return FutureBuilder(
              future: getimage(imageurl),
              builder: (context, snapshot) {
                if (snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return GestureDetector(
                    onTap: () {
                      print(inmyqrs);
                      inmyqrs
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VierMyQr(
                                      imageUrl: snapshot.data.toString(),
                                      item: item)),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoreQr(
                                      imageUrl: snapshot.data.toString(),
                                      item: item)),
                            );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Card(
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.toString(),
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 20.0, 0, 0),
                                  child: Text(
                                    "#${item['qr_code_id']}",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Text("Hello");
                }
              });
        },
      ),
    );
  }
}
