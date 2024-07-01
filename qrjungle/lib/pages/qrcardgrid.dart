import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
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
        return const LoginModalSheet();
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
        setState(() {
          qrlisty = Apiss.myfavslist;
          isloading = false;
        });
        break;

      case 'myqrs':
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

  Future<String> getimage(String item) async {
    try {
      final hi = await Apiss().getPresignedUrl(item);
      return hi;
    } catch (e) {
      print('Error fetching image: $e');
      // Handle error gracefully, e.g., show an error message
      return ''; // Return a default value or handle accordingly
    }
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
      child: (data.isEmpty)
          ? (!loggedinmain)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                    Image.asset('assets/empty.png', height: 200),
                    const SizedBox(height: 15),
                    const Text('Not Logged In :(',
                        style: TextStyle(fontSize: 40)),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
                      Image.asset('assets/empty.png', height: 150),
                      const SizedBox(height: 15),
                      const Text('Empty :(', style: TextStyle(fontSize: 26)),
                    ],
                  ),
                )
          : GridView.builder(
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
                              // shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    width: 100,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0),
                                      ),
                                      child: Skeleton.replace(
                                        width: 100,
                                        height: 200,
                                        child: snapshot.data != null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    snapshot.data.toString(),
                                                fit: BoxFit.cover,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12.0, 10.0, 0, 0),
                                            child: Text(
                                              "#${item['qr_code_id']}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                12.0, 4.0, 0, 0),
                                            child: Text(
                                              "Buy Now",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                12.0, 0.0, 0, 0),
                                            child: Text(
                                              "8.00 \$",
                                              style: TextStyle(
                                                  fontSize: 15.5,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 50.0, 20.0, 0),
                                        child: const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.grey,
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
