import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';
import 'package:nizecart/Screens/cart_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/products/product_controller.dart';
import 'package:intl/intl.dart' as intl;

class FavouriteScreen extends ConsumerStatefulWidget {
  // final Map data;
  FavouriteScreen({Key key}) : super(key: key);

  @override
  ConsumerState<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  bool isFav;
  final formatter = intl.NumberFormat.decimalPattern();
  int quantity = 0;
  static var box = Hive.box('name');

  List product = [];
  List cartItems = box.get('cart', defaultValue: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          title: const Text(
            'Favourite',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Cart(),
            ),
          ],
        ),
        backgroundColor: white,
        body: FutureBuilder(
          future: ref.read(productControllerProvider).getFavProduct(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print('favorite: ${snapshot.data}');
              return snapshot.data.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/cart.png',
                            height: 120,
                            width: 150,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        const Text(
                          'No Favourite Items',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      itemBuilder: (ctx, i) {
                        Map item = snapshot.data[i];
                        return Slidable(
                          startActionPane: ActionPane(
                              extentRatio: 0.25,
                              dragDismissible: false,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // print('delete');
                                    // List<Map> data = snapshot.data;
                                    ref
                                        .read(productControllerProvider)
                                        .removeFavorite(item['productID']);
                                    setState(() {});
                                  },
                                  spacing: 2,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.save,
                                  label: 'Delete',
                                ),
                              ]),
                          child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 3),
                                    blurRadius: 5,
                                    color: Colors.grey.withOpacity(.5),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data[i]['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[i]['title'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '\₦ ' +
                                              formatter.format(
                                                  snapshot.data[i]['price']),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  quantity++;
                                                });
                                                Map productValue = {
                                                  'qty': quantity,
                                                  'price': item['price'],
                                                  'title': item['title'],
                                                  'imageUrl': item['imageUrl'],
                                                };

                                                cartItems.add(productValue);
                                                box.put('cart', cartItems);
                                                print(
                                                  // 'Here are my shop now prdt :$product');
                                                  Get.to(CartScreen()),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: mainColor,
                                                ),
                                                child: const Text(
                                                  'Shop Now',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () {
                                                print(
                                                    "item id: ${item['productID']}");
                                                ref
                                                    .read(
                                                        productControllerProvider)
                                                    .removeFavorite(
                                                        item['favId']);
                                                setState(() {});
                                              },
                                              child: const Text(
                                                'REMOVE',
                                                style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                    );
            }
          }),
        ));
  }
}
