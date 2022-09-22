// import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Screens/product_details.dart';
import 'package:nizecart/Screens/products_list.dart';
import 'package:nizecart/Screens/profile_screen.dart';
import 'package:nizecart/products/product_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key key, this.items}) : super(key: key);
  List<Map<String, dynamic>> items;
  static var box = Hive.box('name');

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController search = TextEditingController();

  List slideView = [
    {
      'image': 'assets/ads1.png',
    },
    {
      'image': 'assets/ads2.png',
    },
    {
      'image': 'assets/chair.png',
    }
  ];

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

  bool isSearch = false;

  void issearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearch = true;
      });
    } else {
      setState(() {
        isSearch = false;
      });
    }
  }

  String name = HomeScreen.box.get('displayName');
  // static FirebaseAuth auth = FirebaseAuth.instance;
  // User user = auth.currentUser;
  final formatter = intl.NumberFormat.decimalPattern();
  int quantity = 0;

  // static box = Hive.box('name');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([
            ref.read(productControllerProvider).searchProduct(search.text),
            ref.read(productControllerProvider).getProduct(),

            // ref.read()
            // ref.read(authtControllerProvider).getUserDetails(),
            // ref.read(authtControllerProvider).getUserCurrentUserData(),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return shimmer(context);
            } else {
              List searchProduct = snapshot.data[0];
              List product = snapshot.data[1];
              List<String> searchList = [];
              print('my Products: ${product}');

              // product.where((element) => element.title.);

              // List<Map<dynamic, dynamic>> searchItems = product;
              // for (var item in searchItems) {
              //   searchList.add(item[0]);
              // }
              //  List<Map<dynamic, dynamic>>
              searchList
                  .where((item) => product.contains(item.contains('title')));

              // print('Current search: ${searchProduct == search.text}');
              // for (var item in searchItems) {
              //   searchList.contains(item);
              // }
              print('my search $searchList');
              return StreamBuilder(
                  stream: ref.read(authtControllerProvider).userDetails(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return shimmer(context);
                    } else {
                      return Column(
                        children: [
                          Container(
                            height: 170,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(30),
                              ),
                              color: secColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(ProfileScreen());
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color.fromARGB(
                                              255, 221, 213, 213),
                                        ),
                                        child: snapshot.data['photoUrl'] == null
                                            ? const Icon(
                                                Iconsax.user,
                                                size: 30,
                                                color: secColor,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      snapshot.data['photoUrl'],
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        'Good ${greeting()} $name !',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .7,
                                      child: TextField(
                                          controller: search,
                                          cursorColor: mainColor,
                                          onChanged: (value) {
                                            issearch(value);
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Search for a product`',
                                            filled: true,
                                            isDense: true,
                                            suffixIcon: Container(
                                              width: 50,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color:
                                                    mainColor.withOpacity(.7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Iconsax.search_normal,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            fillColor: Colors.white,
                                            prefixIconColor: mainColor,
                                            iconColor: mainColor,
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none),
                                          )),
                                    ),
                                    Cart(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          isSearch
                              ?
                              // print(snapshot.data);
                              searchList != []
                                  ? const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        'Search not found',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(20),
                                      shrinkWrap: true,
                                      itemCount: searchList.length,
                                      itemBuilder: (ctx, i) {
                                        print(' my searching $searchList');
                                        return InkWell(
                                          onTap: () {
                                            // Get.back();
                                            // Get.back();
                                            Get.to(ProductScreen());
                                          },
                                          child: Text(
                                            searchList[i],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      },
                                    )
                              : Expanded(
                                  child: Container(
                                    child: RefreshIndicator(
                                      onRefresh: refresh,
                                      color: secColor,
                                      child: SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(
                                          parent: BouncingScrollPhysics(),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 152,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .95,
                                              child: CarouselSlider.builder(
                                                unlimitedMode: true,
                                                enableAutoSlider: true,
                                                itemCount: slideView.length,
                                                slideBuilder: (index) {
                                                  return Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 10,
                                                              top: 20),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 18,
                                                          horizontal: 20),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      AssetImage(
                                                                    slideView[
                                                                            index]
                                                                        [
                                                                        'image'],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "High quality sofa\nstarted",
                                                            style: TextStyle(
                                                                color: priColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          SizedBox(height: 4),
                                                          RichText(
                                                            text:
                                                                const TextSpan(
                                                              text: '70%',
                                                              style: TextStyle(
                                                                  fontSize: 32,
                                                                  color:
                                                                      priColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              children: [
                                                                TextSpan(
                                                                  text: ' off',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        priColor,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: const [
                                                              Text(
                                                                "See all items",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      priColor,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_rounded,
                                                                size: 15,
                                                                color: priColor,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ));
                                                },
                                                slideIndicator:
                                                    CircularSlideIndicator(
                                                  indicatorRadius: 5,
                                                  itemSpacing: 15,
                                                  currentIndicatorColor:
                                                      mainColor,
                                                  indicatorBackgroundColor:
                                                      Colors.white,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Text(
                                                'Top Deals',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 240,
                                              child: ListView.separated(
                                                padding: const EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 15),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: product.length,
                                                separatorBuilder: (ctx, i) =>
                                                    SizedBox(width: 20),
                                                itemBuilder: (ctx, i) {
                                                  Map data = product.reversed
                                                      .toList()[i];
                                                  return TopViews(
                                                    data: data,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Shop from collections!',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Get.to(ProductList(
                                                        data: product,
                                                      )),
                                                      child: const Text(
                                                        "SEE ALL",
                                                        style: TextStyle(
                                                          color: priColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 2),
                                                    const Icon(
                                                      Icons
                                                          .arrow_forward_ios_sharp,
                                                      size: 13,
                                                      color: priColor,
                                                    ),
                                                    SizedBox(width: 20),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridView.builder(
                                              itemCount: product.length < 4
                                                  ? product.length
                                                  : 4,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 10),
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 0.54,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 20,
                                                crossAxisCount: 2,
                                              ),
                                              itemBuilder: (ctx, i) {
                                                Map data = product[i];

                                                // List fav = [products[i]];
                                                // bool enable = favItems.contains(fav);
                                                return MainView(
                                                  data: data,
                                                );
                                              },
                                            ),
                                            SizedBox(height: 40),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      );
                    }
                  });
            }
          }),
    );
  }
}
