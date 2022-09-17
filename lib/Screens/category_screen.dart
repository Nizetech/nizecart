import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nizecart/Screens/product_details.dart';
import 'package:nizecart/Screens/products_list.dart';
import 'package:nizecart/products/product_controller.dart';
import '../Widget/component.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  CategoryScreen({Key key}) : super(key: key);

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  List<String> cat = [
    'Grocery',
    'Homes & Garden',
    'Phones & Tablets',
    'Computing',
    'Electronics',
    'Fashion',
    'Baby Products',
    'Gaming',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: const Text(
          'Catergory',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: FutureBuilder(
        future: ref.read(productControllerProvider).getFavProduct(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loader();
          } else {
            List product = snapshot.data;
            return ListView.separated(
              itemCount: cat.length,
              separatorBuilder: (ctx, i) => Divider(),
              itemBuilder: (ctx, i) {
                return ListTile(
                  onTap: () => Get.to(
                    ProductList(
                      data: product,
                      productName: cat[i],
                    ),
                  ),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  title: Text(
                    cat[i],
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  trailing: Icon(Icons.navigate_next),
                );
              },
            );
          }
        },
      ),
    );
  }
}
