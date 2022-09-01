import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/products/product_controller.dart';

class FavouriteScreen extends ConsumerStatefulWidget {
  final Map data;
  FavouriteScreen({Key key, this.data}) : super(key: key);

  @override
  ConsumerState<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
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
              padding: EdgeInsets.only(
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Cart(),
            ),
          ],
        ),
        backgroundColor: white,
        body:
            // favItems.length == 0
            //     ?
            //      Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Center(
            //             child: Image.asset(
            //               'assets/cart.png',
            //               height: 120,
            //               width: 150,
            //               color: Colors.grey,
            //             ),
            //           ),
            //           SizedBox(height: 10),
            //           const Text(
            //             'No Favourite Items',
            //             style: TextStyle(
            //               color: Colors.grey,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 20,
            //             ),
            //           ),
            //         ],
            //       )
            //:
            FutureBuilder(
          // future: ProductService.getFavProducts(),
          // builder: (context, snapshot) {
          //   if (snapshot.hasData) {
          //     return ListView.builder(
          //       itemCount: favItems.length,
          //       itemBuilder: (context, index) {
          //         return ProductItem(
          //           product: snapshot.data[index],
          //           onTap: () {
          //             Get.toNamed('/product_detail',
          //                 arguments: snapshot.data[index]);
          //           },
          //         );
          //       },
          //     );
          //   } else {
          //     return Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   }
          // }),
          future: ref.read(productControllerProvider).getFavProduct(),

          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return snapshot.data.isEmpty
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
                      itemCount: snapshot.data[0].length,
                      itemBuilder: (ctx, i) {
                        return Slidable(
                          startActionPane: ActionPane(
                              extentRatio: 0.25,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // print('delete');
                                    Map data = snapshot.data[0];
                                    ref
                                        .read(productControllerProvider)
                                        .removeFavorite(data);
                                  },
                                  spacing: 2,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.save,
                                  label: 'Delete',
                                ),
                              ]),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey.withOpacity(.5),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(15),
                            child: snapshot.data[0][i] != null
                                // snapshot.data[0][i].fav == true
                                //     ? IconButton(
                                //         icon: Icon(
                                //           Icons.favorite,
                                //           color: red,
                                //         ),
                                //         onPressed: () {
                                //           ProductService().removeFav(snapshot.data[0][i]);
                                //           Fluttertoast.showToast(
                                //               msg: 'Removed from Favourite',
                                //               toastLength: Toast.LENGTH_SHORT,
                                //               gravity: ToastGravity.BOTTOM,
                                //               timeInSecForIosWeb: 1,
                                //               backgroundColor: Colors.grey,
                                //               textColor: Colors.white,
                                //               fontSize: 16.0);
                                //         },
                                //       )
                                //     : IconButton(
                                //         icon: Icon(
                                //           Icons.favorite_border,
                                //           color: red,
                                //         ),
                                //         onPressed: () {
                                //           ProductService().addFav(snapshot.data[0][i]);
                                //           Fluttertoast.showToast(
                                //               msg: 'Added to Favourite',
                                //               toastLength: Toast.LENGTH_SHORT,
                                //               gravity: ToastGravity.BOTTOM,
                                //               timeInSecForIosWeb: 1,
                                //               backgroundColor: Colors.grey,
                                //               textColor: Colors.white,
                                //               fontSize: 16.0);
                                //         },
                                //       ),
                                //  Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text(
                                //           snapshot.data[0][i].name,
                                //           style: TextStyle(
                                //             fontSize: 20,
                                //             fontWeight: FontWeight.bold,
                                //           ),
                                //         ),
                                //         IconButton(
                                //           icon: Icon(
                                //             Icons.delete,
                                //             color: Colors.red,
                                //           ),
                                //           onPressed: () {
                                //             ProductService().removeFav(snapshot.data[0][i]);
                                //             Fluttertoast.showToast(
                                //                 msg: 'Removed from Favourite',
                                //                 toastLength: Toast.LENGTH_SHORT,
                                //                 gravity: ToastGravity.BOTTOM,
                                //                 timeInSecForIosWeb: 1,
                                //                 backgroundColor: Colors.grey,
                                //                 textColor: Colors.white,
                                //                 fontSize: 16.0);
                                //           },
                                //         ),
                                //       ],
                                //     ),
                                //     SizedBox(height: 10),
                                //     CachedNetworkImage(
                                //       imageUrl: snapshot.data[0][i].image,
                                //       height: 100,
                                //       width: 100,
                                //       fit: BoxFit.cover,
                                //     ),
                                //     SizedBox(height: 10),
                                //     Text(
                                //       '₹ ${snapshot.data[0][i].price}',
                                //       style: TextStyle(
                                //         fontSize: 20,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     SizedBox(height: 10),
                                //     RatingBar(
                                //       initialRating: snapshot.data[0][i].rating,
                                //       itemCount: 5,
                                //       itemSize: 20,
                                //       itemPadding: EdgeInsets.symmetric(horizontal: 2),
                                //       itemBuilder: (context, _) => Icon(
                                //         Icons.star,
                                //         color: Colors.
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data[0][i]
                                              ['imageUrl'],
                                          // favItems.elementAt(i)['image']
                                          width: double.infinity,
                                          height: 120,
                                          fit: BoxFit.fill,
                                        ),
                                      ),

                                      // IconButton(
                                      //   icon: item['isFav']
                                      //       ? Icon(Iconsax.heart5)
                                      //       : const Icon(Iconsax.heart),
                                      //   onPressed: () {
                                      //     setState(() {
                                      //       item['isFav'] = !item['isFav'];
                                      // selectedItem.add(item);
                                      // box.put('fav', selectedItem);
                                      //     });
                                      //   },
                                      //   color: mainColor,
                                      // ),
                                      const SizedBox(height: 3),
                                      Text(
                                        snapshot.data[0][i]['title'],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '\$ ${snapshot.data[0][i]['price']}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 3),
                                      RatingBarIndicator(
                                        rating: 2.75,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 15,
                                        direction: Axis.horizontal,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  )
                                : const Text('No Image'),
                          ),
                        );
                      },
                    );
            }
          }),
        ));
  }
}
