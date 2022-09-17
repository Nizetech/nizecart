import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../Widget/component.dart';

class ProductList extends StatefulWidget {
  final List<dynamic> data;
  final String productName;
  const ProductList({Key key, this.data, this.productName}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName ?? 'Products'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GridView.builder(
          itemCount: widget.data.length,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.54,
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
      ),
    );
  }
}
