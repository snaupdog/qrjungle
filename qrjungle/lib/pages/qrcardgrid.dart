import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/moreqr/moreqr.dart';
import 'package:qrjungle/pages/moreqr/widgets/modals.dart';
import 'package:qrjungle/pages/otpcheck.dart';

class Qrcardgrid extends StatefulWidget {
  final String type;
  final String categoryName;
  const Qrcardgrid({super.key, required this.type, required this.categoryName});

  @override
  State<Qrcardgrid> createState() => _QrcardgridState();
}

class _QrcardgridState extends State<Qrcardgrid> {
  @override
  void initState() {
    super.initState();
    fetchmyqrs();
  }

  void LogInModalSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LoginModalSheet(
          emailController: emailController,
          signInCustomFlow: signInCustomFlow,
          onSuccess: () {
            Fluttertoast.showToast(
                msg: "Logged In!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                textColor: Colors.white,
                fontSize: 18.0);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerify(email: emailController.text),
              ),
            );
          },
        );
      },
    );
  }

  TextEditingController emailController = TextEditingController();
  var qrlisty = [];
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
        });
        break;
      case 'categories':
        await Apiss().getqrfromCategories(widget.categoryName);
        setState(() {
          qrlisty = Apiss.mycatlist;
        });
        break;

      case 'wishlist':
        await Apiss().listFavourites();
        setState(() {
          qrlisty = Apiss.myfavslist;
        });
        break;

      case 'myqrs':
        await Apiss().listmyqrs();
        setState(() {
          qrlisty = Apiss.myqrslist;
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
        child: qrlisty.isEmpty
            ? const Center(
                child: Text(
                  "No QR codes available.",
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
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
                itemCount: qrlisty.length,
                itemBuilder: (context, index) {
                  final imageurl = qrlisty[index]['qr_code_image_url_key'];
                  final item = qrlisty[index];

                  return FutureBuilder(
                      future: getimage(imageurl),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              if (!loggedinmain) {
                                LogInModalSheet(context);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MoreQr(
                                          imageUrl: snapshot.data.toString(),
                                          item: item)),
                                );
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Card(
                                  shadowColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ClipRRect(
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 0, 0),
                                            child: Text(
                                              "${item['qr_code_id']}",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text("Hello");
                        } else {
                          return const Text("asdf");
                        }
                      });
                },
              ),
      ),
    );
  }
}
