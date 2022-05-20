// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/cart_screen.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

const white = Colors.white;
const mainColor = Color(0xffEA4E4E);
const priColor = Color(0xff3634BE);
const secColor = Color(0xff293F48);

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const CustomButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(mainColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: white),
        ),
      ),
    );
  }
}

class ShopListView extends StatelessWidget {
  final double sHeight;
  final double height;
  final double width;
  final String title;
  final String subtitle;
  final String image;

  const ShopListView(
      {Key key,
      this.height,
      this.image,
      this.sHeight,
      this.subtitle,
      this.title,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sHeight,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        separatorBuilder: (ctx, i) => SizedBox(width: 10),
        itemBuilder: (ctx, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height,
                width: width,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black.withOpacity(.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xff343a40),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Cart extends StatefulWidget {
  Cart({Key key, this.items}) : super(key: key);
  List<Map<String, dynamic>> items;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  static var box = Hive.box('name');
  List selectedItems = box.get('cart');

  ValueNotifier _counter = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        CartScreen(),
      ),
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
          ValueListenableBuilder(
            valueListenable: Hive.box('name').listenable(),
            builder: (ctx, Box box, _) {
              // ValueListenableBuilder(
              //   valueListenable: Hive.box('name').listenable(),
              //   builder: (ctx, Box box, _) {
              //     List quantity = box.get(
              //       'cart',
              //       defaultValue: [],
              //     );

              //     return Text(
              //       '${box.get('cart').length}',
              //       style: const TextStyle(
              //         color: white,
              //         fontSize: 12,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     );
              //   },
              // );
              List quantity = box.get(
                'cart',
                defaultValue: [],
              );
              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 16,
                  width: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: mainColor),
                  child: Text(
                    quantity.length.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

int get itemsCount {
  var box = Hive.box('name');
  List selectedItems = box.get('cart');
  return selectedItems == null ? 0 : selectedItems.length;
}

double get totalAmount {
  var totalAmount = 0.0;
  var box = Hive.box('name');
  List selectedItems = box.get('cart');
  if (selectedItems != null) {
    for (var i = 0; i < selectedItems.length; i++) {
      totalAmount += selectedItems[i]['price'] * selectedItems[i]['quantity'];
    }
  }
  return totalAmount.roundToDouble();
}

// void removeItem(int index) {
//   var box = Hive.box('name');
//   List selectedItems = box.get('cart');
//   selectedItems.removeAt(index);
//   box.put('cart', selectedItems);
//   Fluttertoast.showToast(
//     msg: 'Item removed from cart',
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.red,
//     textColor: Colors.white,
//     fontSize: 16.0,
//   );
// }

int get totalQuantity {
  var totalQuantity = 0;
  var box = Hive.box('name');
  List selectedItems = box.get('cart');
  if (selectedItems != null && selectedItems.length > 0) {
    for (var i = 0; i < selectedItems.length; i++) {
      totalQuantity += selectedItems[i]['quantity'];
    }
  }
  return totalQuantity;
}

// void addItem(Map<String, dynamic> item) {
//   var box = Hive.box('name');
//   List selectedItems = box.get('cart');
//   if (selectedItems ) {
//     selectedItems = [];

//   }
// }

Widget loader() {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(mainColor),
    ),
  );
}

void showToast(String label) {
  Fluttertoast.showToast(
    msg: label,
    backgroundColor: Colors.green,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void showErrorToast(String label) {
  Fluttertoast.showToast(
    msg: label,
    backgroundColor: Colors.red,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
  );
}

// String formatDate(Timestamp str) {
//   return DateFormat().add_yMMMEd().format(str.toDate());
// }
 