import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          title: Text(
            'Airpods',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Iconsax.search_normal,
                    size: 20,
                  ),
                  onPressed: (() => Get.to(SearchScreen())),
                ),
                SizedBox(width: 5),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 7, right: 5),
                        child: Icon(
                          Iconsax.shopping_cart,
                          color: white,
                          size: 25,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 16,
                          width: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: mainColor),
                          child: const Text(
                            '2',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(15),
                children: List.generate(
                    20,
                    (index) => Container(
                          height: 400,
                          width: double.infinity,
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
                                image: AssetImage('assets/headset.png'),
                                width: 140,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              // IconButton(
                              //     onPressed: () {},
                              //     icon:
                              Icon(
                                Iconsax.heart,
                                color: mainColor,
                              ),
                              //),
                              RatingBarIndicator(
                                rating: 2.75,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 50.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        )),
              ),
            )
          ],
        ));
  }
}
