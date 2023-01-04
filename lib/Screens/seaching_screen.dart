import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nizecart/Screens/cart_screen.dart';
import 'package:nizecart/Widget/component.dart';

class SearchingScreen extends StatefulWidget {
  Map product;
  SearchingScreen({Key key, this.product}) : super(key: key);

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  static var box = Hive.box('name');
  List cartItems = box.get('cartItems', defaultValue: []);
  int quantity = 1;

  final formatter = intl.NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.product.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            left: 10,
            top: 15,
            right: 10,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 3),
                  blurRadius: 5,
                  color: Colors.grey.withOpacity(.5),
                ),
              ]),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: cartItems.elementAt(index)['imageUrl'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cartItems.elementAt(index)['title'],
                                // '9',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '₦' +
                                      formatter
                                          .format(cartItems
                                              .elementAt(index)['price'])
                                          .toString(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // To remove item
                            Container(
                              padding: const EdgeInsets.all(
                                3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: mainColor.withOpacity(.3),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (cartItems[index]['qty'] > 1) {
                                        setState(() {
                                          cartItems[index]['qty']--;
                                          box.put('cartItem', cartItems);
                                          // Fluttertoast
                                          //     .showToast(
                                          //   msg:
                                          //       'Removed from cart',
                                          //   toastLength: Toast
                                          //       .LENGTH_SHORT,
                                          //   gravity:
                                          //       ToastGravity
                                          //           .BOTTOM,
                                          //   timeInSecForIosWeb:
                                          //       1,
                                          //   backgroundColor:
                                          //       Colors.red,
                                          //   textColor:
                                          //       Colors.white,
                                          //   fontSize: 16.0,
                                          // );
                                        });
                                      }
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 25,
                                      color: secColor,
                                    ),
                                  ),
                                  SizedBox(width: 5),

                                  Text(
                                    cartItems[index]['qty'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: secColor,
                                    ),
                                  ),
                                  // To Add item
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      if (cartItems.contains(
                                          widget.product['productID'])) {
                                        showErrorToast(
                                            'Product already in cart');
                                        return;
                                      } else {
                                        // setState(() {
                                        //   quantity++;
                                        // });

                                        Map productValue = {
                                          'qty': quantity,
                                          'price': widget.product['price'],
                                          'title': widget.product['title'],
                                          'imageUrl':
                                              widget.product['imageUrl'],
                                          'productID':
                                              widget.product['productID'],
                                        };
                                        cartItems.add(productValue);
                                        box.put('cart', cartItems);
                                        // print('Here are my :$products');
                                        Get.to(CartScreen());
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: mainColor,
                                      ),
                                      child: const Text(
                                        'Shop Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
