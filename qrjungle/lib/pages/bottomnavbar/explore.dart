import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/MoreCategory.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> categoryname = [];
  List<String> fakedata = List.filled(12, "Hello");
  List<String> urls = [];
  String token = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    categories();
  }

  categories() async {
    try {
      setState(() {
        categoryname = Apiss.catageroylist
            .map<String>((item) => item['category_name'] as String)
            .toList();

        isLoading = false;
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
          margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 4),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Image.asset('assets/gifgifgif.gif',
                        fit: BoxFit.fitWidth),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                  child: Text('Categories',
                      style: textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                isLoading
                    ? CategoryCard(textTheme, fakedata)
                    : CategoryCard(textTheme, categoryname),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 0, 10),
                  child: Text('All QR Codes',
                      style: textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                  child: Qrcardgrid(type: "all", categoryName: ""),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Skeletonizer CategoryCard(TextTheme textTheme, List<String> categoryname) {
    return Skeletonizer(
      enabled: isLoading,
      enableSwitchAnimation: true,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.95),
        itemCount: categoryname.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(
                    catname: categoryname[index],
                    catimageurl: Apiss.preurl +
                        Apiss.catageroylist[index]['category_icon'],
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Card(
                color: const Color(0xff1b1b1b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.17,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: Apiss.preurl +
                              Apiss.catageroylist[index]['category_icon'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                      child: Text(
                          overflow: TextOverflow.ellipsis,
                          (categoryname[index].toString().replaceFirst(
                              categoryname[index][0],
                              categoryname[index][0].toUpperCase())),
                          style: textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
