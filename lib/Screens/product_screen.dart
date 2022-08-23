import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Models/productService.dart';
// import 'package:nizecart/Screens/cart_screen.dart';
import 'package:nizecart/Screens/search_screen.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'product_details.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductScreen extends StatefulWidget {
  ProductScreen({
    Key key,
  }) : super(key: key);
  // List<Map<String, dynamic>> selectedItems;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

TextEditingController search = TextEditingController();

class _ProductScreenState extends State<ProductScreen> {
  double rating;
  double userRating = 3.0;
  bool isFavorite = false;
  int counter = 0;
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
  var showOnlyFavourites = false;
  String value;

  @override
  Widget build(BuildContext context) {
    //  widget.data['isFav'] = item['isfav'];

    // products = box.get('products', defaultValue: []);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Airpods',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Iconsax.search_normal,
                  size: 20,
                ),
                onPressed: (() => Get.to(SearchScreen())),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                child: Cart(),
              ),
            ],
          )
        ],
      ),
      backgroundColor: white,
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: mainColor.withOpacity(.2),
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: PopupMenuButton(
                      onSelected: (FilterOptions SelectedValue) {
                        setState(() {
                          if (SelectedValue == FilterOptions.Favorites) {
                            showOnlyFavourites = true;
                          } else {
                            showOnlyFavourites = false;
                          }
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          child: Text('Only Favourites'),
                          value: FilterOptions.All,
                        ),
                        const PopupMenuItem(
                          child: Text('Show All'),
                          value: FilterOptions.Favorites,
                        ),
                        const PopupMenuItem(
                          child: Text('Price high to low'),
                          value: FilterOptions.Favorites,
                        ),
                        const PopupMenuItem(
                          child: Text('Discount'),
                          value: FilterOptions.Favorites,
                        ),
                        const PopupMenuItem(
                          child: Text('Rating'),
                          value: FilterOptions.Favorites,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isDense: true,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      alignment: Alignment.bottomCenter,
                      value: value,
                      hint: const Text('Sort by'),
                      onChanged: (String val) {
                        setState(
                          () {
                            value = val;
                          },
                        );
                      },
                      items: const [
                        DropdownMenuItem(
                          child: Text(
                            'All',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: 'All',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Headset',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: 'Headset',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Airpods',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: 'Airpods',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Bt',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: 'Bt',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Macbook',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: 'Macbook',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: ProductService().getProducts(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // print(data);
                return Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.55),
                      shrinkWrap: true,
                      // physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, i) {
                        data = snapshot.data[i];
                        bool favorite = snapshot.data[i]['favorite'];
                        return
                            //  Wrap(
                            // children: [
                            // child:
                            GestureDetector(
                          onTap: () => Get.to(
                            ProductDetailsScreen(),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                // width: MediaQuery.of(context).size.width * .43,
                                width: 150,
                                margin: const EdgeInsets.only(
                                    left: 10, top: 15, right: 0),
                                decoration: BoxDecoration(
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 5,
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data[i]['imageUrl'],
                                      width: 140,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    ),
                                    IconButton(
                                      icon: !isFavorite
                                          ? const Icon(Iconsax.heart5)
                                          : const Icon(Iconsax.heart),
                                      onPressed: () {
                                        if (!isFavorite) {
                                          ProductService()
                                              .removeFavorite(snapshot.data[i]);
                                          setState(() {
                                            isFavorite = false;
                                            showErrorToast(
                                                'Removed from favorites');
                                          });
                                        } else {
                                          setState(() {
                                            ProductService()
                                                .addFavorite(snapshot.data[i]);
                                            setState(() {
                                              isFavorite = true;
                                              showToast('Added to favorites');
                                            });
                                          });
                                        }
                                      },
                                      color: mainColor,
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      snapshot.data[i]['title'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      ' \$' + snapshot.data[i]['price'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 3),
                                    RatingBar.builder(
                                      // initialRating: data['rating'],
                                      updateOnDrag: true,
                                      initialRating: 3,
                                      allowHalfRating: true,
                                      glow: false,
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          rating = rating;
                                        });
                                      },
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20,
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      height: 40,
                                      child: CustomButton(
                                        text: 'Add to cart',
                                        onPressed: () {
                                          setState(
                                            () {
                                              if (!snapshot.data
                                                      .contains('productID')
                                                  // &&
                                                  // !selectedItems.contains('id')
                                                  ) {
                                                quantity++;
                                                // adding items to the cart list which will later be stored using a suitable backend service
                                                Map productItem = {
                                                  'id': snapshot.data[i]
                                                      ['productID'],
                                                  'title': snapshot.data[i]
                                                      ['title'],
                                                  'price': snapshot.data[i]
                                                      ['price'],
                                                  'imageUrl': snapshot.data[i]
                                                      ['imageUrl'],
                                                  'quantity': quantity,
                                                  'rating': rating,
                                                  'qty': quantity,
                                                };
                                                products.add(productItem);
                                                box.put('cart', products);
                                                // ignore: avoid_print
                                                // print(products);
                                                showToast('Added to cart');
                                              } else {
                                                showToast(
                                                    'Item already added to cart');
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 14,
                                right: 20,
                                child: Container(
                                  height: 20,
                                  width: 55,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      color: priColor),
                                  child: const Text(
                                    'Express',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
