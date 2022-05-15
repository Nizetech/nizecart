import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nizecart/Models/cart.dart';
import 'package:nizecart/Screens/checkout_screen.dart';
import 'package:nizecart/Screens/product_screen.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quantity = 0;

  List<Map<String, dynamic>> items;
  // List<Map<String, dynamic>> items = [];

  // List<Map> items = [
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/headset.png',
  //     'price': '\$ 1,499',
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/airpod.png',
  //     'price': '\$ 1,499',
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/bt.png',
  //     'price': '\$ 2,499',
  //   },
  //   {
  //     'title': 'HeadSet Stereo with strong bazz',
  //     'image': 'assets/macbook.png',
  //     'price': '\$ 2,499',
  //   },
  // ];

  final cart = Get.find<Cart>();
  // final cart = Get.to<Cart>();
  Carting cart1 = Carting();

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
          'Cart',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: mainColor.withOpacity(.2),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Cart Summary',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Items (2)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Text('Subtotal', style: TextStyle(fontSize: 16)),
                Spacer(),
                Text('\$${cart1.totalAmount}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...items.map(
                    (item) => Container(
                      width: double.infinity,
                      alignment: Alignment.center,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: AssetImage(item['image']),
                                width: 140,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Iconsax.trash, color: mainColor),
                              SizedBox(width: 10),
                              const Text(
                                'Remove',
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
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
                                      borderRadius: BorderRadius.circular(4),
                                      color: mainColor),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 18,
                                    color: white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 17),
                              Text(quantity.toString()),
                              SizedBox(width: 17),
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
                                      borderRadius: BorderRadius.circular(4),
                                      color: mainColor),
                                  child: const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: CustomButton(
                      text: 'Proceed to Checkout',
                      onPressed: () => Get.to(CheckOutScreen()),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
