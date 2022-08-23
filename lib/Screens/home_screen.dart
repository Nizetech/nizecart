// import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Models/productService.dart';
import 'package:nizecart/Screens/product_screen.dart';
import 'package:nizecart/Screens/profile.dart';
import 'package:nizecart/Screens/search_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.items}) : super(key: key);
  List<Map<String, dynamic>> items;
  static var box = Hive.box('name');

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> refresh() async => setState(() {});

  // final List selectedItems = HomeScreen.box.get('cart');

  String name = HomeScreen.box.get('displayName');
  static FirebaseAuth auth = FirebaseAuth.instance;
  User user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              color: secColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Good ${greeting()} $name !',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(Profile());
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(255, 221, 213, 213)),
                        child: user.photoURL == null
                            ? const Icon(
                                Iconsax.user,
                                size: 30,
                                color: secColor,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: user.photoURL,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextField(
                          controller: search,
                          cursorColor: mainColor,
                          decoration: InputDecoration(
                            hintText: 'Search for a product',
                            filled: true,
                            isDense: true,
                            suffixIcon: Container(
                              width: 50,
                              height: 45,
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(.7),
                                borderRadius: BorderRadius.circular(8),
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
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                          )),
                    ),
                    Cart(),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: RefreshIndicator(
                onRefresh: refresh,
                color: secColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: FutureBuilder(
                      future: ProductService().getProducts(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            enabled: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: loader(),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return snapshot.data[0].length == 0
                              ? const Center(
                                  child: Text(
                                    'No Products Found',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 152,
                                      width: MediaQuery.of(context).size.width *
                                          .95,
                                      child: CarouselSlider.builder(
                                        unlimitedMode: true,
                                        enableAutoSlider: true,
                                        itemCount: slideView.length,
                                        slideBuilder: (index) {
                                          return Container(
                                              margin: const EdgeInsets.only(
                                                  left: 0, right: 10, top: 20),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 18,
                                                      horizontal: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        slideView[index]
                                                            ['image'],
                                                      ),
                                                      fit: BoxFit.cover)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "High quality sofa\nstarted",
                                                    style: TextStyle(
                                                        color: priColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                    text: const TextSpan(
                                                      text: '70%',
                                                      style: TextStyle(
                                                          fontSize: 32,
                                                          color: priColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: [
                                                        TextSpan(
                                                          text: ' off',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: priColor,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: const [
                                                      Text(
                                                        "See all items",
                                                        style: TextStyle(
                                                          color: priColor,
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
                                        slideIndicator: CircularSlideIndicator(
                                          indicatorRadius: 5,
                                          itemSpacing: 15,
                                          currentIndicatorColor: mainColor,
                                          indicatorBackgroundColor:
                                              Colors.white,
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        children: const [
                                          Text(
                                            'Top Deals',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            "SEE ALL",
                                            style: TextStyle(
                                              color: priColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 13,
                                            color: priColor,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 185,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        separatorBuilder: (ctx, i) =>
                                            SizedBox(width: 10),
                                        itemBuilder: (ctx, i) {
                                          Map data = snapshot.data[i];
                                          return ShopListView(
                                            data: data,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Shop from collections!',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 125,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        separatorBuilder: (ctx, i) =>
                                            SizedBox(width: 10),
                                        itemBuilder: (ctx, i) {
                                          Map data = snapshot.data[i];

                                          return ShopListView2(
                                            data: data,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 125,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        separatorBuilder: (ctx, i) =>
                                            SizedBox(width: 10),
                                        itemBuilder: (ctx, i) {
                                          Map data = snapshot.data[i];
                                          return ShopListView2(
                                            data: data,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                        }
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
