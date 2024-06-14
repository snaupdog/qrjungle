import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  final String title;
  const CategoryView({required this.title});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {

  late String _title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title=widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),);
  }
}