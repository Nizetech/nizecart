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
import 'package:intl/intl.dart' as intl;

class FavouriteScreen extends ConsumerStatefulWidget {
  // final Map data;
  FavouriteScreen({Key key}) : super(key: key);

  @override
  ConsumerState<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  bool isFav;
  final formatter = intl.NumberFormat.decimalPattern();

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
        body: FutureBuilder(
          future: ref.read(productControllerProvider).getFavProduct(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print('favorite: ${snapshot.data}');
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
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      itemBuilder: (ctx, i) {
                        return Slidable(
                          startActionPane: ActionPane(
                              extentRatio: 0.25,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // print('delete');
                                    // List<Map> data = snapshot.data;
                                    ref
                                        .read(productControllerProvider)
                                        .removeFavorite(snapshot.data);
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
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
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
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    // padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data[i]['imageUrl'],
                                        // width: 100,
                                        // height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[i]['title'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '\₦ ' +
                                            formatter.format(
                                                snapshot.data[i]['price']),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                          Text(
                                            'REMOVE',
                                            style: TextStyle(
                                              color: mainColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                    );
            }
          }),
        ));
  }
}
