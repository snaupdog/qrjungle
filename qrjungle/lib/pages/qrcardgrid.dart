import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/moreqr/moreqr.dart';

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

  var qrlisty = [];

  Future<void> fetchmyqrs() async {
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
        child: GridView.builder(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoreQr(
                                  imageUrl: snapshot.data.toString(),
                                  item: item)),
                        );
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
