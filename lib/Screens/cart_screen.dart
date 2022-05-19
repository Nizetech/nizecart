import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Models/cart.dart';
import 'package:nizecart/Screens/checkout_screen.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';

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
  int quantity = 0;
  static var box = Hive.box('name');
  List selectedItems = box.get('cart');
  @override
  Widget build(BuildContext context) {
    print(selectedItems);
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
                children: [
                  Text(
                    'Cart Summary',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Items (${selectedItems.length})',
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
              children: const [
                Text('Subtotal', style: TextStyle(fontSize: 16)),
                Spacer(),
                Text(
                  '\$ 2,499',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: selectedItems.length,
              itemBuilder: (ctx, i) {
                return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 10, top: 15, right: 10),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(
                            image: AssetImage(
                              selectedItems.elementAt(i)['image'],
                            ),
                            width: 140,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedItems.elementAt(i)['title'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  selectedItems
                                      .elementAt(i)['price']
                                      .toString(),
                                  style: TextStyle(
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
                              setState(
                                () {
                                  if (selectedItems.elementAt(i)['quantity'] >
                                      1) {
                                    selectedItems.elementAt(i)['quantity']--;
                                    showErrorToast('Removed from Cart');
                                  } else {
                                    if (selectedItems
                                            .elementAt(i)['quantity'] ==
                                        1) return null;
                                  }
                                },
                              );
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
                          const SizedBox(width: 17),
                          Text(selectedItems
                              .elementAt(i)['quantity']
                              .toString()),
                          SizedBox(width: 17),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedItems.elementAt(i)['quantity']++;
                                showToast('Added to Cart');
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
