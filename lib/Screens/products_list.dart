import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Models/data.dart';
import 'package:nizecart/products/product_controller.dart';
import 'package:path_provider/path_provider.dart';

import '../Widget/component.dart';

class ProductList extends ConsumerStatefulWidget {
  final List<Map> data;
  final String productName;
  const ProductList({Key key, this.data, this.productName}) : super(key: key);

  @override
  ConsumerState<ProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductList> {
  Future<void> _deleteCacheDir() async {
    var tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> refresh() async {
    await _deleteCacheDir();
    setState(() {});
  }

  Future<List> productSnap;
  @override
  void initState() {
    productSnap = ref.read(productControllerProvider).getProduct();
    product = widget.data;
    super.initState();
  }

  List<Map> product = [];
  List cat = [];
  int selected = 0;
  List<Map> categoryItem = [];

  @override
  Widget build(BuildContext context) {
    // print('Category cat $cat');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName ?? 'Products'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_outlined),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: white,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder<Object>(
            future: productSnap,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return loader();
              } else {
                List<Map> cat = snapshot.data;
                if (categoryItem.isEmpty) {
                  categoryItem = cat;
                }
                // categoryItem = cat;

                // log('my product== $cat');
                // log('my product oo $category');
                // print('Snap Category cat $category');
                return Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        itemCount: widget.data != null
                            ? product.length
                            : categories.length,
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.only(left: 20, top: 10, right: 20),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(width: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                              height: 40,
                              // width: categories.elementAt(index) == 'All' ? 60 : 44,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.data != null
                                    ? product[index]['tag'] == categories[index]
                                        ? Colors.white
                                        : mainColor.withOpacity(.5)
                                    : selected == index
                                        ? mainColor.withOpacity(.5)
                                        : Colors.white,
                                border: Border.all(
                                  color: widget.data != null
                                      ? product[index]['tag'] ==
                                              categories[index]
                                          ? mainColor
                                          : Colors.transparent
                                      : selected == index
                                          ? Colors.transparent
                                          : mainColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.data != null
                                    ? product[index]['tag']
                                    : categories.elementAt(index),
                                style: TextStyle(
                                  color: widget.data != null
                                      ? product[index]['tag'] ==
                                              categories[index]
                                          ? Colors.black
                                          : Colors.white
                                      : selected == index
                                          ? Colors.white
                                          : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                print('tapped===');
                                selected = index;
                                // category = snap;
                                if (categories[index] == 'All Products') {
                                  categoryItem = cat;

                                  print('Category all == $categoryItem');
                                } else {
                                  // widget.data != null
                                  //     ? product = product
                                  //         .where((element) =>
                                  //             element['tag'] == product[index])
                                  //         .toList()
                                  //     :
                                  categoryItem = cat
                                      .where((element) =>
                                          element['tag'] == categories[index])
                                      .toList();
                                  print(
                                      'Category filter== ${categories[index]}');
                                  print('Category filter== $categoryItem');
                                  // showErrorToast('Faled to change');
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: widget.data != null
                            ? product.length
                            : categoryItem.length,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.54,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (ctx, i) {
                          // categoryItem = cat;
                          // print(' how cat ${cat.length}');
                          // print(' Wrong cat ${cat}');

                          return MainView(
                            data: widget.data != null
                                ? product[i]
                                : categoryItem[i],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
