import 'package:flutter/material.dart';
import 'package:nizecart/Models/data.dart';
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

  List cat = [];
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName ?? 'Products'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: ListView.separated(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(20),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(width: 10),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = index;
                      });
                    },
                    child: Container(
                      // height: 60,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selected == index
                            ? mainColor.withOpacity(.5)
                            : Colors.white,
                        border: Border.all(
                            color: selected == index
                                ? Colors.transparent
                                : Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        categories.elementAt(index),
                        style: TextStyle(
                            color:
                                selected == index ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
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

                  return MainView(
                    data: data,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
