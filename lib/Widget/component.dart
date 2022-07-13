import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/cart_screen.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Screens/product_screen.dart';

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
  final Map data;

  const ShopListView({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductScreen());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: 150,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: data['imageUrl'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            data['title'],
            maxLines: 1,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black.withOpacity(.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            data['price'],
            style: const TextStyle(
              color: Color(0xff343a40),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

class ShopListView2 extends StatelessWidget {
  final Map data;

  const ShopListView2({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductScreen());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 90,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: data['imageUrl'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            data['title'],
            maxLines: 1,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black.withOpacity(.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            data['price'],
            style: const TextStyle(
              color: Color(0xff343a40),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
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
