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
        print(Apiss.catageroylist);
        print(categoryname);
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
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
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
                  child: Image.asset(
                    'assets/gifgifgif.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text('Categories',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              isLoading
                  ? CategoryCard(textTheme, fakedata)
                  : CategoryCard(textTheme, categoryname),
              Text('All QR Codes',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const Qrcardgrid(type: "all", categoryName: "")
            ],
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
            crossAxisSpacing: 7.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1),
        itemCount: categoryname.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryPage(
                            catname: categoryname[index],
                            catimageurl: 'assets/qrsample.png',
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 135,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: Image.asset('assets/qrsample.png',
                            fit: BoxFit.cover),

                        // child: CachedNetworkImage(
                        //   imageUrl:
                        //       "https://img.cutenesscdn.com/640/media-storage/contentlab-data/11/12/85a43f6b7a904946a3a3b125273fc548.jpeg",
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 0),
                      child: Text(
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
