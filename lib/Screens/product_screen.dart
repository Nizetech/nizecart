import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/products/product_controller.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart' as intl;

import 'product_details.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductScreen extends ConsumerStatefulWidget {
  ProductScreen({
    Key key,
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

  void removeFav(Map data) {
    setState(() {
      isFavorite = false;
      ref.read(productControllerProvider).removeFavorite(data);
    });
  }

  final formatter = intl.NumberFormat.decimalPattern();
  List cartItems = box.get('cart', defaultValue: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Products',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Icon(
                Iconsax.search_normal,
                size: 20,
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
            future: ref.read(productControllerProvider).getProduct(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // print(data);
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, i) {
                        print(snapshot.data);
                        return Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              // width: MediaQuery.of(context).size.width * .43,
                              width: double.infinity,
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                    color: Colors.grey.withOpacity(.5),
                                  ),
                                ],
                              ),
                              // padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data[i]['imageUrl'],
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                          itemSize: 15,
                                          direction: Axis.horizontal,
                                        ),
                                        IconButton(
                                          icon: isFavorite
                                              ? const Icon(Iconsax.heart5)
                                              : const Icon(Iconsax.heart),
                                          onPressed: () {
                                            !isFavorite
                                                ? addFav(snapshot.data[i])
                                                : removeFav(snapshot.data[i]);
                                          },
                                          color: mainColor,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          snapshot.data[i]['title'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),

                                        SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  size: 30,
                                                  color: mainColor,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    // quantity--;
                                                    cartItems[i]['qty']--;
                                                    box.put(
                                                        'cartItem', cartItems);
                                                    showErrorToast(
                                                        'Removed from cart');
                                                  });
                                                },
                                              ),
                                              Text(
                                                '₦' +
                                                    formatter
                                                        .format(snapshot.data[i]
                                                            ['price'])
                                                        .toString(),
                                                // '₦' +
                                                //     formatter
                                                //         .format(data['price'])
                                                //         .toString(),
                                                // '8',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: mainColor,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (!snapshot.data
                                                              .contains(
                                                                  'productID')
                                                          // &&
                                                          // !selectedItems.contains('id')
                                                          ) {
                                                        quantity++;
                                                        // adding items to the cart list which will later be stored using a suitable backend service
                                                        Map productItem = {
                                                          'id': snapshot.data[i]
                                                              ['productID'],
                                                          'title': snapshot
                                                              .data[i]['title'],
                                                          'price': snapshot
                                                              .data[i]['price']
                                                              .toString(),
                                                          'imageUrl':
                                                              snapshot.data[i]
                                                                  ['imageUrl'],
                                                          'quantity': quantity,
                                                          'rating': rating,
                                                          'qty': quantity,
                                                        };
                                                        products
                                                            .add(productItem);
                                                        box.put(
                                                            'cart', products);

                                                        showToast(
                                                            'Added to cart');
                                                      } else {
                                                        showToast(
                                                            'Item already added to cart');
                                                      }
                                                    });
                                                  }),
                                            ]),
                                        // SizedBox(
                                        //   height: 40,
                                        //   child: CustomButton(
                                        //     text: 'Add to cart',
                                        //     onPressed: () {},
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                height: 20,
                                width: 55,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(20)),
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
                        );
                        //   } ,
                        // );
                        // Expanded(
                        //   child: GridView.builder(
                        //       gridDelegate:
                        //           const SliverGridDelegateWithFixedCrossAxisCount(
                        //               crossAxisCount: 2, childAspectRatio: 0.55),
                        //       shrinkWrap: true,
                        //       // physics: BouncingScrollPhysics(),
                        //       itemCount: snapshot.data.length,
                        //       itemBuilder: (ctx, i) {
                        //         data = snapshot.data[i];
                        //         return GestureDetector(
                        //           onTap: () => Get.to(
                        //             ProductDetailsScreen(),
                        //           ),
                        //           child:

                        //         );
                        // );
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
