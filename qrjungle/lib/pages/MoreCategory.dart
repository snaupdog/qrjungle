import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  final String catname;
  const CategoryPage({required this.catname, super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String catname = '';

  @override
  void initState() {
    super.initState();
    // Initialize catname with the value passed from the widget
    catname = widget.catname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Page'),
      ),
      body: Center(
        child: Text(
          'Expanded page after tapping: $catname',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}