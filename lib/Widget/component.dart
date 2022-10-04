import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/cart_screen.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Screens/product_details.dart';
import 'package:nizecart/products/product_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart' as intl;

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

class TopViews extends StatefulWidget {
  final Map data;

  TopViews({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<TopViews> createState() => _TopViewsState();
}

class _TopViewsState extends State<TopViews> {
  final formatter = intl.NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductScreen(
          data: widget.data,
        ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.data['imageUrl'],
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data['title'],
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '₦' + formatter.format(widget.data['price']).toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MainView extends ConsumerStatefulWidget {
  final Map data;

  MainView({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  final formatter = intl.NumberFormat.decimalPattern();
  bool enable = false;

  // final Map data;
  List products = [];

  int quantity = 0;
  static var box = Hive.box('name');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductScreen(data: widget.data));
      },
      child: Container(
        height: 250,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(-9, -12),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          enable = !enable;
                        });
                        if (enable) {
                          ref
                              .read(productControllerProvider)
                              .addFavorite(widget.data);
                          showErrorToast('Removed from favorite');
                        } else {
                          ref
                              .read(productControllerProvider)
                              .removeFavorite(widget.data['favId']);
                          setState(() {});
                        }
                        showToast('Added to favorite');
                      },
                      icon: Icon(
                        // fav.contains(
                        enable
                            // )
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red[600],
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: secColor,
                  ),
                  child: Text(
                    '20%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.data['imageUrl'],
                height: 100,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 2,
            ),
            SizedBox(height: 10),
            Text(
              widget.data['title'],
              textAlign: TextAlign.left,
              maxLines: 2,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
            RatingBar.builder(
              // initialRating: widget.dataating'],
              updateOnDrag: true,
              initialRating: 3,
              allowHalfRating: true,
              glow: false,
              onRatingUpdate: (rating) {
                setState(() {
                  rating = rating;
                });
              },
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₦' + formatter.format(widget.data['price']),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text(
                      '₦ 978',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                    Map productValue = {
                      'qty': quantity,
                      'price': widget.data['price'],
                      'title': widget.data['title'],
                      'imageUrl': widget.data['imageUrl'],
                    };
                    products.add(productValue);
                    box.put('cart', products);
                    // print('Here are my :$products');
                    Get.to(CartScreen());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          ],
        ),
      ),
    );
  }
}

class Cart extends ConsumerWidget {
  Cart({Key key, this.items}) : super(key: key);
  List<Map<String, dynamic>> items;

//   @override
//   State<Cart> createState() => _CartState();
// }

// class _CartState extends State<Cart> {
  static var box = Hive.box('name');
  // List selectedItems = box.get('cart');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('Total quantity: ${selectedItems.length}');
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
                  // ignore: unrelated_type_equality_checks
                  child: quantity.length == []
                      ? const Text(
                          '0',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          ' ${quantity.length}',
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

// void addItem(Map<String, dynamic> item) {
//   var box = Hive.box('name');
//   List selectedItems = box.get('cart');
//   if (selectedItems ) {
//     selectedItems = [];
//   }
// }

dynamic loading(String label) {
  Get.dialog(
    Material(
      color: Colors.black.withOpacity(.2),
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(mainColor),
              ),
              SizedBox(height: 20),
              Text(label, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    ),
  );
}

Widget loader() {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(mainColor),
    ),
  );
}

dynamic showToast(String label) {
  return Get.snackbar(
    'Success',
    label,
    duration: Duration(seconds: 1),
    backgroundColor: Colors.green,
    colorText: white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.only(
      bottom: 20,
      right: 20,
      left: 20,
    ),
  );
}

dynamic showErrorToast(String label) {
  return Get.snackbar(
    'Error',
    label,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.only(
      bottom: 20,
      right: 20,
      left: 20,
    ),
  );
}

// String formatDate(Timestamp str) {
//   return DateFormat().add_yMMMEd().format(str.toDate());
// }

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

class AccountListTile extends StatelessWidget {
  const AccountListTile({Key key, this.text, this.onTap}) : super(key: key);
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Iconsax.shop),
      title: Text(
        text,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: const Icon(Icons.navigate_next_sharp),
      // onTap: () => Get.to(ManageProduct()),
    );
  }
}

Widget shimmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    enabled: true,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40)),
                color: Colors.grey),
          ),
          SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 152,
                    width: MediaQuery.of(context).size.width * .95,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 10, width: 50, color: Colors.grey),
                      Container(height: 10, width: 50, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 185,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (ctx, i) => SizedBox(width: 10),
                      itemBuilder: (ctx, i) {
                        return Container(
                          height: 185,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 10, width: 50, color: Colors.grey),
                      Container(height: 10, width: 50, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 185,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (ctx, i) => SizedBox(width: 10),
                      itemBuilder: (ctx, i) {
                        return Container(
                          height: 125,
                          width: 145,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class RecieverMsg extends StatelessWidget {
  final String message;
  final String date;
  final String userName;

  const RecieverMsg({Key key, this.message, this.date, this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(15),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(27),
                topRight: Radius.circular(27),
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(27),
              ),
              color: Color(0xfff2f2f2),
            ),
            child: Column(
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 3),
                Text(
                  message,
                  style: TextStyle(
                    color: Color(0xff3a3a41),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 13),
        Text(
          date,
          style: TextStyle(
            color: Color(0xff3a3a41),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}

// class SenderMsg extends StatelessWidget {
//   final String message;
//   final String date;
//   final String userName;
//   final Map messageData;

//   const SenderMsg({Key key, this.message, this.date, this.userName})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Align(
//           alignment: Alignment.centerRight,
//           child: Container(
//             padding: EdgeInsets.all(15),
//             constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * .7),
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(27),
//                 topRight: Radius.circular(27),
//                 bottomLeft: Radius.circular(27),
//                 bottomRight: Radius.circular(2),
//               ),
//               color: Color(0xff4b4b4b),
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   userName,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 Text(
//                   message,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 13),
//         Text(
//           date,
//           style: TextStyle(
//             color: Color(0xff3a3a41),
//             fontSize: 10,
//             fontWeight: FontWeight.w700,
//           ),
//         )
//       ],
//     );
//   }
// }

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const CustomTextField({Key key, this.controller, this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: mainColor,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        isDense: true,
        prefixIconColor: mainColor,
        fillColor: white,
        iconColor: mainColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
