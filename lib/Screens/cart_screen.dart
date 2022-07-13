import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/Screens/checkout_screen.dart';
import '../Widget/component.dart';

class CartScreen extends StatefulWidget {
  CartScreen({
    Key key,
    // this.items
  }) : super(key: key);
  // List<Map<String, dynamic>> items;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // int quantity = 0;
  // int subtotal = 0;
  static var box = Hive.box('name');

  // Get total quantity
  get totalQuantity {
    var total = 0;
    for (var element in cartItems) {
      total += element['qty'];
    }
    return total;
  }

  // Get total Amount
  get totalAmount {
    var totalAmount = 0;
    for (var element in cartItems) {
      totalAmount += element['price'] * element['qty'];
    }
    return totalAmount.toString();
  }

  // double get totalAmount {
  //   var totalAmount = 0.0;
  //   if (cartItems.isNotEmpty) {
  //     for (var i = 0; i < cartItems.length; i++) {
  //       totalAmount += int.parse(cartItems[i]['price']) *
  //           int.parse(cartItems[i]['quantity']);
  //     }
  //   }
  //   return totalAmount.roundToDouble();
  // }

  // int get totalQuantity {
  //   var totalQuantity = 0;
  //   if (cartItems != null) {
  //     for (var i = 0; i < cartItems.length; i++) {
  //       totalQuantity += counter;
  //       // box.add(totalQuantity);
  //       counter = totalQuantity;
  //     }
  //   }
  //   return totalQuantity;
  // }
  // Map data = cartItems[index];

  List cartItems = box.get('cart', defaultValue: []);
  @override
  Widget build(BuildContext context) {
    // Map data = cartItems[0];
    print(cartItems[0]);
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
      body:
          //  !cartItems.contains(0)
          // cartItems.isEmpty
          cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/cart.png',
                        fit: BoxFit.cover,
                        color: Colors.grey,
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'No items in cart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: mainColor.withOpacity(.2),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Cart Summary',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // total quantity of all items in cart
                            Text(
                              // '0',
                              // 'Items 00',
                              // 'Items ($totalAmount)',
                              'Items ($totalQuantity)',
                              style: const TextStyle(
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
                          // total amount of all items in cart
                          Text(
                            // '\$$totalAmount'.toString(),
                            // 'total ' + '$totalAmount.',
                            // totalAmount as String,
                            '0',
                            // '\$$totalAmount'.toString(),

                            // '₦' + totalAmount.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //List of items in cart
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        // itemCount: 2,
                        itemCount: cartItems.length,
                        itemBuilder: (ctx, i) {
                          print(cartItems[0]);
                          return Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 10, top: 15, right: 10),
                            decoration: BoxDecoration(color: white, boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 3),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(.5),
                              ),
                            ]),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          cartItems.elementAt(i)['imageUrl'],
                                      width: 140,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(width: 0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItems.elementAt(i)['title'],
                                            // '9',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            '₦' +
                                                cartItems
                                                    .elementAt(i)['price']
                                                    .toString(),
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
                                    GestureDetector(
                                      onTap: () {
                                        // cartItems.elementAt(i)['quantity'] == 0
                                        //     ? null
                                        //      :
                                        setState(() {
                                          cartItems.removeAt(i);
                                          box.put('cartItem', cartItems);
                                          Fluttertoast.showToast(
                                            msg: 'Item removed from cart',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        });
                                      },
                                      child: const Text(
                                        'Remove',
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    // To remove item
                                    GestureDetector(
                                      onTap: () {
                                        if (cartItems[i]['qty'] > 1) {
                                          setState(() {
                                            cartItems[i]['qty']--;
                                            box.put('cartItem', cartItems);
                                            Fluttertoast.showToast(
                                              msg: 'Item removed from cart',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          });
                                        }
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
                                    const SizedBox(width: 17),
                                    Text(
                                      cartItems[i]['qty'].toString(),
                                    ),
                                    SizedBox(width: 17),
                                    // To Add item
                                    GestureDetector(
                                      onTap: () {
                                        if (cartItems[i]['qty'] < 10) {
                                          setState(
                                            () {
                                              cartItems[i]['qty']++;
                                              box.put('cartItem', cartItems);
                                              showToast('Added to cart');
                                            },
                                          );
                                        } else {
                                          showErrorToast(
                                              'Max quantity reached');
                                        }
                                        // setState(
                                        //   () {
                                        //     if (cartItems[0]['qty'] < 10) {
                                        //       cartItems[0]['qty']++;

                                        //       // box.put('cartItem', cartItems);
                                        //       showToast('Added to Cart');
                                        // cartItems = [];
                                        // } else if (cartItems.contains(
                                        //   cartItems.elementAt(i),
                                        // )) {
                                        //   cartItems.addAll(
                                        //     cartItems.elementAt(i),
                                        //   );
                                        //     } else {
                                        //       showErrorToast(
                                        //           'Item limit reached');
                                        //     }
                                        //   },
                                        // );
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
                                ),
                                SizedBox(height: 20),
                                // CustomButton(
                                //   onPressed: () => Get.to(CheckOutScreen()),
                                // ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
