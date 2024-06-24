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
    //QRbyCategory();
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
    print('All categoriesss: $categoryname');
  }

    // QRbyCategory() async {
    // try {
    //   print("This is the QRByCategory api being called!\n");
    //   for (int i=0;i>categoryname.length;i++){
    //     var res = await Apiss().getqrfromCategories(categoryname[i]);
    //     print('RESSSSSSSSSSSSSSSSSSSSSS: $res');}
    // } catch (e) {
    //   print('Error!');
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
    
    //print('All categories: $categoryname');
  // }

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
            Text('All QR Codes',
                style: _textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 20),
            const QrCards(),
          ],
        ),
      ),
    );
  }
}








// CATEGORIES SIDE SCROLL BAR

 // Text('Categories', style: _textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            // SizedBox(height:10),
            // SizedBox(
            //   height: 60,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: categoriesCount,
            //     itemBuilder: (context, index) {
            //       return InkWell(
            //         onTap: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (context) => CategoryDetailPage(categoryName: categoryname[index]),
            //           //   ),
            //           // );
            //         },
            //         child: Container(
            //           margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            //           padding: EdgeInsets.fromLTRB(9, 5, 9, 5),
            //           decoration: BoxDecoration(                        
            //             borderRadius: BorderRadius.circular(25),
            //             color: Color.fromARGB(255, 39, 39, 39),
            //           ),
            //           child: Center(
            //             child: Text(
            //               (categoryname[index].toString().replaceFirst(categoryname[index][0], categoryname[index][0].toUpperCase())),
            //               style: _textTheme.bodySmall?.copyWith(fontSize: 15),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),