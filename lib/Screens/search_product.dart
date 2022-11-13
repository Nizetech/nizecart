import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/products/product_controller.dart';

class SearchProduct extends ConsumerStatefulWidget {
  final String query;
  const SearchProduct({Key key, this.query}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchProductState();
}

class _SearchProductState extends ConsumerState<SearchProduct> {
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    search.text = widget.query;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: SizedBox(),
        leadingWidth: 0,
        title: TextField(
          controller: search,
          onSubmitted: (val) {
            search.text = val;
            setState(() {});
          },
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future:
              //  ref.read(productControllerProvider).getProduct(),
              ref.read(productControllerProvider).searchProduct(search.text),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loader();
            } else {
              List product = snapshot.data;
              log('$product');
              // product = product
              //     .where(
              //         (val) => val['title'].contains(search.text.toLowerCase()))
              //     .toList();
              print('My product $product oooo');

              return product.isEmpty || product == null
                  ? Center(child: Text('Not Available'))
                  : ListView.separated(
                      itemCount: product.length,
                      separatorBuilder: (ctx, i) => SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        return Text(product[i]['title']);
                      });
            }
          }),
    );
  }
}
