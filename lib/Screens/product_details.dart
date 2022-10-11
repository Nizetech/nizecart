import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Auth/screens/signInScreen.dart';
import 'package:nizecart/Screens/cart_screen.dart';
import 'package:nizecart/products/product_controller.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart' as intl;

import 'product_details.dart';

// enum FilterOptions {
//   Favorites,
//   All,
// }

class ProductScreen extends ConsumerStatefulWidget {
  final Map data;
  ProductScreen({
    Key key,
    this.data,
  }) : super(key: key);
  // List<Map<String, dynamic>> selectedItems;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

TextEditingController search = TextEditingController();

class _ProductScreenState extends ConsumerState<ProductScreen> {
  double rating;
  double userRating = 3.0;
  bool isFavorite = false;
  // bool fav = false;
  int quantity = 0;
  int price = 0;
  int total = 0;
  Map data = {};
  List products = [];

  @override
  void initState() {
    super.initState();
    rating = userRating;
  }

  static var box = Hive.box('name');
  String value;

  void favorite(map) {
    if (!isFavorite) {
      ref.read(productControllerProvider).removeFavorite(map);
      // setState(() {
      isFavorite = false;
      showErrorToast('Removed from favorites');
      // });
    } else {
      ref.read(productControllerProvider).addFavorite(map);
      // setState(() {
      isFavorite = true;
      showToast('Added to favorites');
      // });
    }
  }

  void addFav(Map data) {
    setState(() {
      isFavorite = true;
      ref.read(productControllerProvider).addFavorite(data);
    });
  }

  void removeFav(String productID) {
    setState(() {
      isFavorite = false;
      ref.read(productControllerProvider).removeFavorite(productID);
    });
  }

  final formatter = intl.NumberFormat.decimalPattern();

  bool enable = false;

  List cartItems = box.get('cart', defaultValue: []);
  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: Container(
          width: 60,
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(50),
              )),
          child: BackButton(color: Colors.black),
        ),
        actions: [
          Container(
            width: 60,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(50),
                )),
            child: IconButton(
              onPressed: () {
                if (isLoggedIn) {
                  setState(() {
                    enable = !enable;
                  });
                  if (enable) {
                    ref
                        .read(productControllerProvider)
                        .addFavorite(widget.data);
                  } else {
                    ref
                        .read(productControllerProvider)
                        .removeFavorite(widget.data['favId']);
                  }
                } else {
                  Get.to(SignInScreen());
                }
              },
              icon: Icon(
                enable ? Icons.favorite : Icons.favorite_border,
                color: Colors.red[600],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xffF0F0F0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              fillOverscroll: true,
              child:
                  // LayoutBuilder(builder: (context, snapshot) {
                  // return
                  //  SingleChildScrollView(
                  //   child: ConstrainedBox(
                  //     constraints: BoxConstraints(maxHeight: Get.height / .98),
                  //     child: IntrinsicHeight(
                  // child:
                  Stack(children: [
                Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 8,
                        height: MediaQuery.of(context).size.height * 15,
                        child: CachedNetworkImage(
                          imageUrl: widget.data['imageUrl'],
                        ),
                      ),
                    ),
                    Spacer(flex: 5),
                  ],
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 78,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .8,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              RatingBar.builder(
                                // initialRating: widget.dataating'],
                                updateOnDrag: true,
                                initialRating: 3,
                                allowHalfRating: false,
                                glow: false,
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    rating = rating;
                                  });
                                },
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15,
                                direction: Axis.horizontal,
                              ),
                              SizedBox(width: 3),
                              const Text(
                                '(24 Reviews)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: secColor,
                            ),
                            child: const Text(
                              '20%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₦' + formatter.format(widget.data['price']),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 5),
                              const Text(
                                '₦ 12,000',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                splashColor: mainColor,
                                onTap: () {
                                  // if (isLoggedIn) {
                                  setState(() {
                                    quantity++;
                                  });

                                  Map productValue = {
                                    'qty': quantity,
                                    'price': widget.data['price'],
                                    'title': widget.data['title'],
                                    'imageUrl': widget.data['imageUrl'],
                                    'id': widget.data['productID'],
                                  };
                                  if (cartItems.isNotEmpty) {
                                    toast('Product already exist in cart');
                                    return;
                                  } else {
                                    // products.add(productValue);
                                    cartItems.add(productValue);
                                    box.put('cart', cartItems);
                                    showToast('Added to cart');
                                  }
                                  // } else {
                                  //   Get.to(SignInScreen());
                                  // }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: mainColor),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'Add To Cart',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  if (isLoggedIn) {
                                    setState(() {
                                      quantity++;
                                    });
                                    Map<String, dynamic> productValue = {
                                      'qty': quantity,
                                      'price': widget.data['price'],
                                      'title': widget.data['title'],
                                      'imageUrl': widget.data['imageUrl'],
                                    };
                                    products.add(productValue);
                                    // box.add(products);
                                    cartItems.add(productValue);
                                    box.put('cart', cartItems);
                                    setState(() {});

                                    Get.to(CartScreen());
                                  } else {
                                    Get.to(SignInScreen());
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'Shop Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(
                            thickness: 2,
                            color: Colors.grey[200],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Description :',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.data['description'],
                            // 'knoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc minHeight: constraint.maxHeightminHeight: constraint.maxHeightminHeight: constraint.maxHeightminHeight: constraint.maxHeightminHeight: constraint.maxHeightminHeight: constraint.maxHeightminHeight: constraint.maxHeightminHeight: constraint.maxHeightminHeight: constraint.maxHeightvjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkh knoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhvvvknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkhknoinhuiohougougfyuyifyicyifcyifyucutcuycutucyvtucuycuc vjhvyivhvivhvihvhviyhvkhviyhvkhviyhvyiivhvyivhkvyivkh',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),
              ]),
            ),
          ],
        ),
        // );
        // }),
      ),
      // ],
      // ),
      // );
      //////Custom
    );
  }
}
