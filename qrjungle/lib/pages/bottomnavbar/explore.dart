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
      var items = await Apiss().getCategories();

      setState(() {
        categoryname = items
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
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AnimatedContainer(
                  duration: Duration(seconds: 4),
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
              SizedBox(height: 40),
              Text('Categories',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              isLoading
                  ? newMethod(textTheme, fakedata)
                  : newMethod(textTheme, categoryname),
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

  Skeletonizer newMethod(TextTheme textTheme, List<String> categoryname) {
    return Skeletonizer(
      enabled: isLoading,
      enableSwitchAnimation: true,
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.08, crossAxisCount: 2),
          itemCount: categoryname.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPage(
                              catname: categoryname[index],
                              catimageurl: 'assets/qrsample.png',
                            )));
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                height: MediaQuery.sizeOf(context).height * 0.2,
                width: MediaQuery.sizeOf(context).width * 0.43,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  color: Color(0xff1B1B1B),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.13,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(13)),
                          child: Image.asset('assets/qrsample.png',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5.5),
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
            );
          }),
    );
  }
}
