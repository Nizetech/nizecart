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

  List cat = [];
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    List<Map> product = widget.data;
    List<Map> cat = product;
    List<Map> category = [];
    // print('Category cat $cat');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName ?? 'Products'),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder<Object>(
            future: ref.read(productControllerProvider).getProduct(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return loader();
              } else {
                List<Map> snap = snapshot.data;
                category = snap;
                // log('my product $snap');
                // log('my product oo $category');
                // print('Snap Category cat $category');
                return Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        itemCount: categories.length,
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
                                color: selected == index
                                    ? mainColor.withOpacity(.5)
                                    : Colors.white,
                                border: Border.all(
                                  color: selected == index
                                      ? Colors.transparent
                                      : mainColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                categories.elementAt(index),
                                style: TextStyle(
                                  color: selected == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            onTap: () {
                              // setState(() {
                              //   selected = index;
                              //   if (gallery[index] == 'All') {
                              //     images = fullImages;
                              //   } else {
                              //     images = fullImages
                              //         .where(
                              //             (element) => element['type'] == gallery[index])
                              //         .toList();
                              //   }
                              // });
                              setState(() {
                                // category = snap;
                                selected = index;
                                if (categories[index] == 'All Products') {
                                  category = snap;
                                  // showToast('done');
                                  // print('Category cat $category');
                                } else {
                                  category = snap
                                      .where((element) =>
                                          element['tag'] == categories[index])
                                      .toList();
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
                        itemCount:
                            widget.data != null ? cat.length : category.length,
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
                          print(' Wrong cat ${category}');
                          return MainView(
                            data: widget.data != null ? cat[i] : category[i],
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
