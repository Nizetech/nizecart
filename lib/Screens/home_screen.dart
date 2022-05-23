// import 'dart:async';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Screens/product_screen.dart';
import 'package:nizecart/Screens/search_screen.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.items}) : super(key: key);
  List<Map<String, dynamic>> items;

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
  static var box = Hive.box('name');
  List selectedItems = box.get('cart');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Container(
            height: 150,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              color: secColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/NIZECART.png',
                  height: 42,
                  width: 100,
                  fit: BoxFit.contain,
                  color: white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextField(
                          controller: search,
                          obscureText: true,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 152,
                      width: MediaQuery.of(context).size.width * .95,
                      child: CarouselSlider.builder(
                        unlimitedMode: true,
                        enableAutoSlider: true,
                        itemCount: slideView.length,
                        slideBuilder: (index) {
                          return Container(
                              margin:
                                  EdgeInsets.only(left: 0, right: 10, top: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(
                                        slideView[index]['image'],
                                      ),
                                      fit: BoxFit.cover)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "High quality sofa\nstarted",
                                    style: TextStyle(
                                        color: priColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 4),
                                  RichText(
                                      text: const TextSpan(
                                          text: '70%',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 32,
                                              color: priColor,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                        TextSpan(
                                            text: ' off',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: priColor,
                                            ))
                                      ])),
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
                                        Icons.arrow_forward_rounded,
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
                          indicatorBackgroundColor: Colors.white,
                          padding: EdgeInsets.only(
                            bottom: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
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
                    GestureDetector(
                      onTap: () {
                        // Get.to(ProductScreen());
                      },
                      child: const ShopListView(
                        sHeight: 185,
                        height: 130,
                        width: 150,
                        image: 'assets/airpod.png',
                        title: "FreeBuds Huawei",
                        subtitle: "\$ 1,499 ",
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
                    GestureDetector(
                      onTap: () {
                        // Get.to(ProductScreen());
                      },
                      child: const ShopListView(
                        sHeight: 130,
                        height: 70,
                        width: 90,
                        image: 'assets/headset.png',
                        title: "Alexa Home",
                        subtitle: "\$ 999 ",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.to(ProductScreen());
                      },
                      child: const ShopListView(
                        sHeight: 130,
                        height: 70,
                        width: 90,
                        image: 'assets/bt.png',
                        title: "Alexa Home",
                        subtitle: "\$ 999 ",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
