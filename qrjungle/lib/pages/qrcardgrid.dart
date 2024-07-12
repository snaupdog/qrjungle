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
    "qr_code_image_url_key": "",
    "qr_code_id": "fake",
    "qr_prompt": "fake",
    "price": "5.00 \$"
  };
  late List<Map<String, dynamic>> fakedata;

  MyClass() {
    fakedata = List.filled(6, hi);
  }
}

class _QrcardgridState extends State<Qrcardgrid> {
  late List<Map<String, dynamic>> fakedata;
  TextEditingController emailController = TextEditingController();
  var qrlisty = [];
  bool inmyqrs = false;
  bool isloading = true;

  @override
  void initState() {
    fakedata = MyClass().fakedata;
    super.initState();
    fetchmyqrs();
  }

  Future<void> fetchmyqrs() async {
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
        // await Apiss().listFavourites();
        setState(() {
          qrlisty = Apiss.myfavslist;
          isloading = false;
        });
        break;

      case 'myqrs':
        Apiss().listmyqrs();
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

  Future<void> toggleFavourite(String item) async {
    if (Apiss.favqrsids.contains(item)) {
      Apiss.favqrsids.remove(item);
    } else {
      Apiss.favqrsids.add(item);
    }
    await Apiss().addFavourites(Apiss.favqrsids);
    setState(() {
      Apiss().listFavourites();
    });
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
      enableSwitchAnimation: false,
      child: (data.isEmpty || data.contains(Null))
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
                bool liked = false;
                final item = data[index];
                final imageurl = item['qr_code_image_url_key'];
                if (Apiss.favqrsids.contains(item['qr_code_id'])) {
                  liked = true;
                }

                return GestureDetector(
                  onTap: () {
                    inmyqrs
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VierMyQr(
                                    imageUrl: Apiss.preurl + imageurl,
                                    item: item)),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MoreQr(
                                      imageUrl: Apiss.preurl + imageurl,
                                      item: item,
                                    )),
                          ).then((_) {
                            setState(() {
                              Apiss().listFavourites();
                              if (widget.type == "wishlist") {
                                qrlisty = Apiss.myfavslist;
                              }
                            });
                          });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Card(
                        color: const Color(0xff1b1b1b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              // height: 200,
                              height: constraints.maxHeight * 0.7,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Skeletonizer(
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.grey[
                                          300], // Adjust the color as needed
                                    ),
                                  ),
                                  imageUrl: Apiss.preurl + imageurl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            inmyqrs
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 0, 0),
                                    child: Text(
                                      "#${item['qr_code_id']}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : Row(
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
                                                12.0, 10.0, 0, 0.0),
                                            child: Text(
                                              "#${item['qr_code_id']}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                12.0, 3.0, 0, 0.0),
                                            child: Text(
                                              "500 INR",
                                              //                       hardcodede price,
                                              // "${item['price']} INR",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.5,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 5, 4),
                                        child: IconButton(
                                          icon: liked
                                              ? const Icon(Icons.favorite)
                                              : const Icon(
                                                  Icons.favorite_border),
                                          onPressed: () async {
                                            if (loggedinmain) {
                                              setState(() {
                                                liked = !liked;
                                              });
                                              await toggleFavourite(
                                                  item['qr_code_id']);
                                            } else {
                                              print("show modal sheet");
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    const LoginModalSheet(),
                                              );
                                            }
                                          },
                                          color: liked
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),
    );
  }
}
