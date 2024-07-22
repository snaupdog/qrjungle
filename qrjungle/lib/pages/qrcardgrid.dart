import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/moreqr/moreqr.dart';
import 'package:qrjungle/pages/moreqr/viewmyqr.dart';
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
      case 'myqrs':
        Apiss().listmyqrs();
        setState(() {
          qrlisty = Apiss.myqrslist;
          isloading = false;
        });
        break;
      default:
        print("Defailt");
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
                final item = data[index];
                final imageurl = item['qr_code_image_url_key'];

                return GestureDetector(
                  onTap: () {
                    (widget.type == 'myqrs')
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VierMyQr(
                                    imageUrl: Apiss.preurl + imageurl,
                                    item: item)),
                          ).then((_) {
                            setState(() {
                              qrlisty = Apiss.myqrslist;
                            });
                          })
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MoreQr(
                                      imageUrl: Apiss.preurl + imageurl,
                                      item: item,
                                    )),
                          );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Stack(
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          return Card(
                            color: const Color(0xff1b1b1b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      placeholder: (context, url) =>
                                          Skeletonizer(
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
                                (widget.type == 'myqrs')
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 10.0, 0, 10),
                                        child: Text(
                                          "#${item['qr_code_id']}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12.0, 0.0, 0, 0.0),
                                                  child: Text(
                                                    "#${item['qr_code_id']}",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      12.0, 0.0, 0, 0.0),
                                                  child: Text(
                                                    "499 INR",
                                                    //                       hardcodede price,
                                                    // "${item['price']} INR",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.5,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          );
                        }),
                        if (widget.type == 'myqrs' &&
                            (item['redirect_url'].isEmpty ||
                                item['redirect_url'] == 'https://'))
                          Positioned(
                            top: 10,
                            left: 10,
                            right: 80,
                            child: Container(
                              height: 25, // Example height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFff5e62),
                                    Color(0xFFff9966),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.9),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(
                                        0, 5), // Offset to give a glow effect
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'No Url',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
