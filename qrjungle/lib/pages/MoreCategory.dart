import 'package:flutter/material.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';

class CategoryPage extends StatefulWidget {
  final String catname;
  final String catimageurl;

  CategoryPage({required this.catname, required this.catimageurl});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.sizeOf(context).height * 0.25,
            leading: Container(), // Hides the default back button
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 10, bottom: 7),
              title: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    const BackButton(),
                    Text(
                      widget.catname.toString().replaceFirst(
                          widget.catname[0], widget.catname[0].toUpperCase()),
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/qrsample.png'),
                    fit: BoxFit.cover,
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 10, bottom: 16),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(14),
              child: Column(
                children: [
                  Qrcardgrid(type: "categories", categoryName: widget.catname)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
