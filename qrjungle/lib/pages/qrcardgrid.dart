import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';

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
    fetchmyqrs();
    super.initState();
  }

  var qrlisty = [];

  fetchmyqrs() async {
    // await Apiss().clearlist()
    switch (widget.type) {
      case 'all':
        await Apiss().getAllqrs("");
        print(Apiss.allqrslist);
        setState(() {
          qrlisty = Apiss.allqrslist;
        });
        break;
      case 'categories':
        await Apiss().getqrfromCategories(widget.categoryName);
        break;

      case 'wishlist':
        await Apiss().listFavourites();
        break;

      case 'myqrs':
        await Apiss().listmyqrs();
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
    return Padding(
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
                  return Container(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Card(
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
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
                  );
                } else if (snapshot.hasError) {
                  return const Text("Hello");
                } else {
                  return const Text("asdf");
                }
              });
        },
      ),
    );
  }
}
