import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/profile/order_history.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/keys/keys.dart';
import 'package:nizecart/products/product_controller.dart';

class OrderScreen extends ConsumerWidget {
  OrderScreen({Key key}) : super(key: key);
  static var box = Hive.box('name');
  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: white,
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: white,
      body: FutureBuilder(
          future: ref.read(productControllerProvider).getOrder(),
          builder: (context, snapshot) {
            List order = snapshot.data;
            // log("my Orderssss: ${order}");
            if (!snapshot.hasData) {
              return loader();
            } else {
              if (isLoggedIn && order.isNotEmpty) {
                return ListView.separated(
                  itemCount: order.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 10),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(OrderHistory(
                          data: order[index],
                        ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(.5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                      imageUrl: order[index]['productDetails']
                                          [0]['imageUrl']),
                                )),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order[index]['productDetails'][0]['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.amber,
                                    ),
                                    child: const Text(
                                      'Pending',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    formatTime(order[index]['ordered_date']),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/cart.png',
                        height: 120,
                        width: 150,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'No Orders yet!!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                );
              }
            }
          }),
      // ),
    );
  }
}
