import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';

class CategoryPage extends StatefulWidget {
  final String catname;
  final String catimageurl;

  const CategoryPage(
      {super.key, required this.catname, required this.catimageurl});

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
            backgroundColor: Colors.transparent,
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: NetworkImage(widget.catimageurl),
                    image: CachedNetworkImageProvider(widget.catimageurl),
                    fit: BoxFit.cover,
                  ),
                  // color: const Color.fromARGB(255, 255, 255, 255),
                  color: Colors.black,
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 10, bottom: 16),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Qrcardgrid(type: "categories", categoryName: widget.catname),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
