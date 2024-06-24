import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis.dart';

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
  }

  categories() async {
    try {
      print("This is the categories api being called!\n");
      var res = await Apiss().listQrCategories(token);
      var items = res['data']['items'];
      setState(() {
        print(items);
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
    print('All categories: $categoryname');
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    int categoriesCount = categoryname.length;
    print(categoriesCount);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories',
                style: _textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesCount,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CategoryDetailPage(categoryName: categoryname[index]),
                      //   ),
                      // );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 39, 39, 39),
                      ),
                      child: Center(
                        child: Text(
                          (categoryname[index].toString().replaceFirst(
                              categoryname[index][0],
                              categoryname[index][0].toUpperCase())),
                          style: _textTheme.bodySmall?.copyWith(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Text('All QR Codes',
                style: _textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            //GridView.builder(
            //shrinkWrap: true,
            //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            //itemBuilder: (context, index) {
            //return
            const QrCards(),
            // },
            //),
          ],
        ),
      ),
    );
  }
}
