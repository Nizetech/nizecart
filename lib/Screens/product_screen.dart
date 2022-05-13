import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nizecart/Screens/cartScreen.dart';
import 'package:nizecart/Screens/search_screen.dart';
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
  int counter = 0;
  bool fav = false;
  int quantity = 1;
  List<Map> items = [
    {
      'title': 'HeadSet Stereo with strong bazz',
      'image': 'assets/headset.png',
      'price': '\$ 1,499'
    },
    {
      'title': 'HeadSet Stereo with strong bazz',
      'image': 'assets/airpod.png',
      'price': '\$ 1,499'
    },
    {
      'title': 'HeadSet Stereo with strong bazz',
      'image': 'assets/bt.png',
      'price': '\$ 2,499'
    },
    {
      'title': 'HeadSet Stereo with strong bazz',
      'image': 'assets/macbook.png',
      'price': '\$ 2,499'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: white,
        backgroundColor: secColor,
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
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                child: Cart(),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Wrap(
              children: items
                  .map(
                    (item) => Stack(children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * .43,
                        margin: EdgeInsets.only(left: 10, top: 15, right: 10),
                        decoration: BoxDecoration(color: white, boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(.5),
                          ),
                        ]),
                        padding: EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage(item['image']),
                                width: 140,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              Icon(
                                Iconsax.heart,
                                color: mainColor,
                              ),
                              SizedBox(height: 3),
                              Text(
                                item['title'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 3),
                              Text(
                                item['price'].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 3),
                              RatingBarIndicator(
                                rating: 2.75,
                                itemBuilder: (context, index) => const Icon(
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
                                        if (quantity > 1) {
                                          quantity--;
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
                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  Text(quantity.toString()),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: mainColor),
                                      child: Icon(
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
    );
  }
}
