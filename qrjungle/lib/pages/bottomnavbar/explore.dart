//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis_rest.dart';
import 'package:qrjungle/pages/MoreCategory.dart';
//import 'package:qrjungle/pages/moreqr/moreqr.dart';

import '../qrcards/qr_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> categoryname = [];
  List<String> urls = [];
  String token = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    categories();
    //QRbyCategory();
  }

  categories() async {
    try {

      var hi = await ApissRest().getCategories();

      var items = hi;
      print('THIS IS ITEMS !! ! ! ! ! !  $items');
      setState(() {
        // print(items);
        categoryname = items
            .map<String>((item) => item['category_name'] as String)
            .toList();
        isLoading = false;
        print(categoryname);
      });
    } catch (e) {
      print('Error!');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text('Categories',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Container(                
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.08,
                            crossAxisCount: 2),
                    itemCount: categoryname.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                      catname: categoryname[index], catimageurl: 'assets/qrsample.png',)));
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          height: MediaQuery.sizeOf(context).height * 0.2,
                          width: MediaQuery.sizeOf(context).width * 0.43,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13)),
                              color:
                               Color(0xff1B1B1B),
                              ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.13,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(13)),
                                    child: Image.asset('assets/qrsample.png',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(5.5),
                                child: Text(
                                    (categoryname[index]
                                        .toString()
                                        .replaceFirst(
                                            categoryname[index][0],
                                            categoryname[index][0]
                                                .toUpperCase())),
                                    style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Text('All QR Codes',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const QrCards(catagories: false, categoryName: "all"),
            ],
          ),
        ),
      ),
    );
  }
}
