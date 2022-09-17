import 'package:flutter/material.dart';

import '../Widget/component.dart';

class ProductList extends StatefulWidget {
  final List<dynamic> data;
  final String productName;
  const ProductList({Key key, this.data, this.productName}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName ?? 'Products'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: widget.data.length,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.57,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
        ),
        itemBuilder: (ctx, i) {
          Map data = widget.data[i];

          // List fav = [products[i]];
          // bool enable = favItems.contains(fav);
          return MainView(
            data: data,
          );
        },
      ),
    );
  }
}
