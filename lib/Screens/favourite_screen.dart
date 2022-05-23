import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  List selectedItems = box.get('cart');
  List favItems = box.get('fav');

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
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: Cart(),
            ),
          ],
        ),
        backgroundColor: white,
        body: favItems.length == 0
            ? Column(
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
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: favItems.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * .43,
                    margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
                    decoration: BoxDecoration(
                      color: white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          color: Colors.grey.withOpacity(.5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage(favItems.elementAt(i)['image']),
                          width: 140,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        // IconButton(
                        //   icon: item['isFav']
                        //       ? Icon(Iconsax.heart5)
                        //       : const Icon(Iconsax.heart),
                        //   onPressed: () {
                        //     setState(() {
                        //       item['isFav'] = !item['isFav'];
                        //       // selectedItem.add(item);
                        //       // box.put('fav', selectedItem);
                        //     });
                        //   },
                        //   color: mainColor,
                        // ),
                        SizedBox(height: 3),
                        Text(
                          favItems.elementAt(i)['title'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '\$${favItems.elementAt(i)['price']}'.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        RatingBarIndicator(
                          rating: 2.75,
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    if (favItems.elementAt(i)['quantity'] !=
                                            0 ||
                                        favItems.elementAt(i)['quantity'] !=
                                            null) {
                                      favItems.removeAt(i);

                                      box.put('favItem', selectedItems);
                                      showErrorToast('Removed from Cart');
                                    } else {
                                      null;
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
                                  Iconsax.trash,
                                  size: 25,
                                  color: white,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: CustomButton(
                                  text: 'Add to cart',
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (favItems.elementAt(i)['quantity'] <
                                                1 &&
                                            !favItems.contains('id')) {
                                          favItems.elementAt(1)['quantity']++;
                                          // adding items to the cart list which will later be stored using a suitable backend service
                                          selectedItems
                                              .add(favItems.elementAt(i));
                                          box.put('favItem', selectedItems);
                                          // ignore: avoid_print
                                          // print(selectedItem);
                                          showToast('Added to cart');
                                        }
                                        // else if (favItems
                                        //     .contains(favItems.elementAt(i))) {
                                        //   favItems.addAll(favItems.elementAt(i));
                                        // }
                                        else {
                                          showToast(
                                              'Item already added to cart');
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                        // Row(
                        //   mainAxisAlignment:
                        //       MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         setState(
                        //           () {
                        //             if (item['quantity'] > 0 &&
                        //                 item.containsKey(
                        //                     'quantity')) {
                        //               item['quantity']--;
                        //               selectedItem.remove(item);
                        //               print(selectedItem);
                        //               box.delete('quantity');
                        //               showErrorToast(
                        //                   'Removed from Cart');
                        //             }
                        //           },
                        //         );
                        //       },
                        //       child: Container(
                        //         padding: EdgeInsets.all(6),
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //             borderRadius:
                        //                 BorderRadius.circular(4),
                        //             color: mainColor),
                        //         child: const Icon(
                        //           Icons.remove,
                        //           size: 18,
                        //           color: white,
                        //         ),
                        //       ),
                        //     ),
                        //     Text(item['quantity'].toString()),
                        //     GestureDetector(
                        //       onTap: () {
                        //         setState(
                        //           () {
                        //             if (item['quantity'] < 10 &&
                        //                 item.containsKey(
                        //                     'quantity')) {
                        //               item['quantity']++;
                        //               // adding items to the cart list which will later be stored using a suitable backend service
                        //               selectedItem.add(item);
                        //               box.put('cart', selectedItem);
                        //               // ignore: avoid_print
                        //               print(selectedItem);
                        //               showToast('Added to cart');
                        //             }
                        //           },
                        //         );
                        //       },
                        //       child: Container(
                        //         padding: EdgeInsets.all(6),
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //             borderRadius:
                        //                 BorderRadius.circular(4),
                        //             color: mainColor),
                        //         child: const Icon(
                        //           Icons.add,
                        //           size: 18,
                        //           color: white,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  );
                },
              ));
  }
}
