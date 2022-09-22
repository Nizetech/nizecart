import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart' as intl;

import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/Screens/checkout_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../Widget/component.dart';

class CartScreen extends ConsumerStatefulWidget {
  CartScreen({
    Key key,
    // this.items
  }) : super(key: key);
  // List<Map<String, dynamic>> items;

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  // int quantity = 0;
  // int subtotal = 0;
  static var box = Hive.box('name');
  final formatter = intl.NumberFormat.decimalPattern();

  Future<void> _deleteCacheDir() async {
    var tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  List cartItems = box.get('cart', defaultValue: []);

  // Get total Amount
  int get totalAmount {
    var totalAmount = 0;
    for (var element in cartItems) {
      totalAmount += element['price'] * element['qty'];
      // print(totalAmount);
      print('runt time ${element['price'].runtimeType}');
      print('runt time ${element['qty'].runtimeType}');
    }
    return totalAmount;
  }

  // Get total quantity
  int get totalQuantity {
    var total = 0;
    for (var element in cartItems) {
      total += element['qty'];
    }
    box.put('quantity', total);
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // Map data = cartItems[0];
    // print(cartItems);
    // print('Total Amount: $totalAmount');
    print('Total Cart: ${cartItems}');
    // print('TotalQuantity $totalQuantity');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: white,
        backgroundColor: secColor,
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: white,
      body:
          // !cartItems.contains(0)
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
                              // '₦ ' + formatter.format(totalAmount).toString(),
                              'pp',
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
                          const Text('Total Items',
                              style: TextStyle(fontSize: 16)),

                          const Spacer(),
                          // total amount of all items in cart
                          Text(
                            // '( ${totalQuantity.toString()} )',
                            'ii',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
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
                        itemCount: cartItems.length,
                        itemBuilder: (ctx, i) {
                          print(cartItems[0]);
                          // box.put(
                          //   'title',
                          //   cartItems.elementAt(i)['title'],
                          // );
                          // box.put(
                          //   'description',
                          //   cartItems.elementAt(i)['description'],
                          // );
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
                                        imageUrl:
                                            cartItems.elementAt(i)['imageUrl'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  cartItems
                                                      .elementAt(i)['title'],
                                                  // '9',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    '₦' +
                                                        formatter
                                                            .format(cartItems
                                                                .elementAt(
                                                                    i)['price'])
                                                            .toString(),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // To remove item
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  3,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color:
                                                      mainColor.withOpacity(.3),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (cartItems[i]
                                                                ['qty'] >
                                                            1) {
                                                          setState(() {
                                                            cartItems[i]
                                                                ['qty']--;
                                                            box.put('cartItem',
                                                                cartItems);
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  'Removed from cart',
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0,
                                                            );
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
                                                      cartItems[i]['qty']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: secColor,
                                                      ),
                                                    ),
                                                    // To Add item
                                                    SizedBox(width: 5),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (cartItems[i]
                                                                ['qty'] <
                                                            10) {
                                                          setState(
                                                            () {
                                                              cartItems[i]
                                                                  ['qty']++;
                                                              box.put(
                                                                  'cartItem',
                                                                  cartItems);
                                                              showToast(
                                                                  'Added to cart');
                                                            },
                                                          );
                                                        } else {
                                                          showErrorToast(
                                                              'Max quantity reached');
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.add,
                                                        size: 25,
                                                        color: secColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  // cartItems.elementAt(i)['quantity'] == 0
                                                  //     ? null
                                                  //      :
                                                  cartItems.clear();
                                                  Hive.box('name').clear();
                                                  // await _deleteCacheDir();
                                                  setState(() {
                                                    // box.put(
                                                    //     'cartItem', cartItems);
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          'Item removed from cart',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ),
        child: CustomButton(
          text: 'Checkout  (₦',
          // ${formatter.format(totalAmount).toString()}
          // )',
          onPressed: () {
            return Get.to(
              CheckOutScreen(totalAmount: totalAmount),
            );
          },
        ),
      ),
    );
  }
}
