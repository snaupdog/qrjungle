import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/MoreCategory.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/customform.dart';
import 'package:qrjungle/pages/moreqr/widgets/modals.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

List<String> customcategoryname = [];
bool isLoading = true;

class _CustomPageState extends State<CustomPage> {
  final List<String> images = [
    'assets/qr1.png',
    'assets/qr2.png',
    'assets/qr3.png',
    'assets/qr4.png',
    'assets/qr5.png',
  ];

  List<String> fakedata = List.filled(12, "Hello");

  final List<String> imageTexts = [
    'Restaurant Menus',
    'Google Reviews',
    'Information Redirects',
    'Quick Links',
    'Social Media Links'
  ];

  @override
  void initState() {
    super.initState();
    categories();
  }

  categories() async {
    try {
      setState(() {
        print(Apiss.customcategorielist);
        customcategoryname = Apiss.customcategorielist
            .map<String>((item) => item['category_name'] as String)
            .toList();

        print("this ist $Apiss.customcategorielist");
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
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(35, 20, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Do you want a custom QR?',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                                onPressed: () {
                                  if (loggedinmain) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CustomForm()));
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          const LoginModalSheet(),
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(5, 8, 8, 5),
                                  child: Center(
                                    child: Text('Get Started!',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Image.asset('assets/qrsqrs.png', height: 160))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Use custom QRs for: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationThickness: 3)),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Swiper(
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          images[index],
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                        const SizedBox(height: 0),
                        Text(
                          imageTexts[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    );
                  },
                  autoplay: true,
                  loop: true,
                  viewportFraction: 0.4,
                  scale: 0.4,
                  layout: SwiperLayout.DEFAULT,
                  itemHeight: 250,
                  itemWidth: 250,
                  pagination: const SwiperPagination(
                    builder: RectSwiperPaginationBuilder(
                      activeColor: Colors.cyan,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? CategoryCard(textTheme, fakedata)
                  : CategoryCard(textTheme, customcategoryname),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
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
                        catimageurl:
                            "https://images.unsplash.com/photo-1443428018053-13da55589fed?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D"
                        //hardcoded
                        // catimageurl: Apiss.preurl +
                        //     Apiss.customcategorielist[index]['category_icon'],
                        )));
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
                    height: MediaQuery.sizeOf(context).height * 0.135,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://images.unsplash.com/photo-1443428018053-13da55589fed?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D",
                        // imageUrl: Apiss.preurl +
                        //     Apiss.customcategorielist[index]['category_icon'],
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
