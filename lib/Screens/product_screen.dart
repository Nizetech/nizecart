import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:nizecart/Screensscreen.dart';
import 'package:nizecart/Screens/search_screen.dart';
import '../Models/product.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

TextEditingController search = TextEditingController();

class _ProductScreenState extends State<ProductScreen> {
  // int counter = 0;
  // bool fav = false;
  // int quantity = 1;
  // int price = 0;
  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'HeadSet Stereo with strong bazz',
      // imageUrl: 'assets/headset.png',
      price: 1.499,
      isFav: false,

      // rating: 4.5,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Product(
      id: 'p2',
      title: 'HeadSet Stereo with strong bazz',
      // imageUrl: 'assets/airpod.png',
      price: 1.499,
      isFav: false,
      // rating: 4.5,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Product(
      id: 'p3',
      title: 'HeadSet Stereo with strong bazz',
      // imageUrl: 'assets/bt.png',
      price: 1.499,
      isFav: false,

      // rating: 4.5,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Product(
      id: 'p4',
      title: 'HeadSet Stereo with strong bazz',
      isFav: false,

      price: 1.499,
      // rating: 4.5,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Product(
      id: 'p5',
      title: 'HeadSet Stereo with strong bazz',
      // imageUrl: 'assets/headset.png',
      price: 1.499,
      isFav: false,
      // rating: 4.5,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
  ];
  // List<Map<String, dynamic>> items = [
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/headset.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/airpod.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/bt.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/macbook.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/headset.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/airpod.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/bt.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/macbook.png',
  //     'price': 1.499,
  //     'isFav': false,
  //     'quantity': 1,
  //   },
  // ];

  String value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
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
              SizedBox(width: 5),
              const Padding(
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                alignment: Alignment.bottomCenter,
                value: value,
                hint: const Text(' Sort by'),
                onChanged: (String val) {
                  setState(() {
                    value = val;
                  });
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                      children: loadedProducts
                          .map(
                            (item) => Stack(children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * .43,
                                margin: EdgeInsets.only(
                                    left: 10, top: 15, right: 10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                          // loadedProducts[0].id,
                                          loadedProducts[0].image,
                                          // loadedProducts[0].price,
                                          // loadedProducts[0].isFav,
                                          // loadedProducts[0].quantity
                                        ),
                                        width: 140,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      ),
                                      IconButton(
                                        icon: loadedProducts[0].isFav
                                            ? Icon(Iconsax.heart5)
                                            : const Icon(Iconsax.heart),
                                        onPressed: () {
                                          setState(() {
                                            loadedProducts[0].isFav =
                                                !loadedProducts[0].isFav;
                                          });
                                        },
                                        color: mainColor,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        loadedProducts[0].title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        '\$${loadedProducts[0].price}'
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 3),
                                      RatingBarIndicator(
                                        rating: 2.75,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 15,
                                        direction: Axis.horizontal,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (loadedProducts[0].quantity >
                                                    1) {
                                                  loadedProducts[0].quantity--;
                                                  showErrorToast(
                                                      'Removed from Cart');
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: mainColor),
                                              child: const Icon(
                                                Icons.remove,
                                                size: 18,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                          Text(loadedProducts[0]
                                              .quantity
                                              .toString()),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (loadedProducts[0].quantity <
                                                    10) {
                                                  loadedProducts[0].quantity++;
                                                  showToast('Added to cart');
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: mainColor),
                                              child: const Icon(
                                                Icons.add,
                                                size: 18,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                              Positioned(
                                top: 14,
                                right: 10,
                                child: Container(
                                    height: 20,
                                    width: 55,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            bottomLeft: Radius.circular(10)),
                                        color: priColor),
                                    child: const Text(
                                      'Express',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                            ]),
                          )
                          .toList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
