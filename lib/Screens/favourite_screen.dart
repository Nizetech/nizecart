import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Widget/component.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({Key key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  static var box = Hive.box('name');
  // List favItems = box.get('fav');
  List favItems = box.get('fav');
  // var box = box.get('fav');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: const Text(
          'Favourite',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: favItems.contains('fav')
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: itemsCount,
              itemBuilder: (ctx, i) {
                return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
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
                              favItems.elementAt(i)['image'],
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
                                  favItems.elementAt(i)['title'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  favItems.elementAt(i)['price'].toString(),
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
                              setState(
                                () {
                                  if (favItems.elementAt(i)['quantity'] > 1) {
                                    favItems.elementAt(i)['quantity']--;
                                    showErrorToast('Removed from Cart');
                                  } else {
                                    if (favItems.elementAt(i)['quantity'] ==
                                        1) {
                                      return null;
                                    }
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
                          Text(favItems.elementAt(i)['quantity'].toString()),
                          SizedBox(width: 17),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                favItems.elementAt(i)['quantity']++;
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
            )
          : Column(
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
                  'No Favourite Items',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
    );
  }
}
