import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Screens/products_list.dart';
import 'package:nizecart/chat/chat_screen.dart';
import 'package:nizecart/keys/keys.dart';
import 'package:nizecart/products/product_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart' as intl;

import '../Widget/component.dart';

class OrderHistory extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  OrderHistory({Key key, this.data}) : super(key: key);

  @override
  ConsumerState<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends ConsumerState<OrderHistory> {
  final formatter = intl.NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    print("my data: ${widget.data}");
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Order History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: white,
      body: FutureBuilder(
          future: Future.wait([
            ref.read(productControllerProvider).getProduct(),
            ref.read(authtControllerProvider).getUserDetails(),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loader();
            } else {
              List product = snapshot.data[0];
              Map user = snapshot.data[1];
              return CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: true,
                  fillOverscroll: true,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 3),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thanks for your order!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Image.asset(
                                    'assets/white_cart.png',
                                    color: mainColor,
                                    height: 30,
                                    width: 30,
                                  )
                                ],
                              ),
                              RichText(
                                  text: TextSpan(
                                text: 'Order No. : ',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.data['orderID'],
                                    style: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            mainColor.withOpacity(.8),
                                        radius: 15,
                                        child: Icon(Icons.pending_actions,
                                            color: white, size: 20),
                                      ),
                                      SizedBox(height: 3),
                                      const Text(
                                        'Pending',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                      child: Transform.translate(
                                    offset: Offset(0, -6),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  )),
                                  Column(
                                    children: const [
                                      CircleAvatar(
                                        backgroundColor: Colors.amber,
                                        radius: 15,
                                        child: Icon(Icons.flight_takeoff,
                                            color: white, size: 20),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Shipping',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                      child: Transform.translate(
                                    offset: Offset(0, -6),
                                    child: const Divider(
                                      color: Colors.grey,
                                    ),
                                  )),
                                  Column(
                                    children: const [
                                      CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 15,
                                        child: Icon(Icons.check,
                                            color: white, size: 20),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Delivered',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              const Text(
                                'ORDER SUMMARY',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(height: 5),
                              Text(
                                formatTime(widget.data['ordered_date']),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Items',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Shipping Details',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: widget
                                            .data['productDetails'].length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                  text: TextSpan(
                                                text: 'Title : ',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: widget.data[
                                                            'productDetails']
                                                        [index]['title'],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              SizedBox(height: 5),
                                              RichText(
                                                  text: TextSpan(
                                                text: 'Price : ',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: '₦' +
                                                        formatter
                                                            .format(widget.data[
                                                                    'productDetails']
                                                                [
                                                                index]['price'])
                                                            .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'roboto',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              SizedBox(height: 5),
                                              RichText(
                                                  text: TextSpan(
                                                text: 'Quantity : ',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: widget
                                                        .data['productDetails']
                                                            [index]['qty']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              SizedBox(height: 20),
                                            ],
                                          );
                                        }),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.data['address'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        widget.data['email'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      RichText(
                                          text: TextSpan(
                                        text: '${widget.data['city']}, ',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.data['country'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      )),
                                      SizedBox(height: 3),
                                      RichText(
                                          text: TextSpan(
                                        text: 'Postal Code: ',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.data['postCode'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )),
                                      SizedBox(height: 3),
                                      RichText(
                                          text: TextSpan(
                                        text: 'Track No. : ',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.data['trackNumber'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ))
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              RichText(
                                  text: TextSpan(
                                text: 'Total: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: ' ₦ ' +
                                        formatter
                                            .format(widget.data['totalAmount'])
                                            .toString(),
                                    style: TextStyle(
                                      fontFamily: 'roboto',
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )),
                              Divider(),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                color: mainColor.withOpacity(.2),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Shop from collections!',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          return Get.to(ProductList(
                                            data: product,
                                          ));
                                        },
                                        child: const Text(
                                          "SEE ALL",
                                          style: TextStyle(
                                            color: priColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        size: 13,
                                        color: priColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: CarouselSlider.builder(
                                  unlimitedMode: true,
                                  enableAutoSlider: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      product.length < 4 ? product.length : 4,
                                  viewportFraction: .4,
                                  slideBuilder: (index) {
                                    Map data = product[index];
                                    return OrderView(
                                      data: data,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200]),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Need Help?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    const Text(
                                      'For any further info. please click on this link below  to contact out amazing customer support.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                              ),
                                              context: context,
                                              builder: (contex) {
                                                return Container(
                                                  height: 170,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(20),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        leading: const Icon(
                                                          Iconsax.call_calling,
                                                          size: 25,
                                                          color: Colors.green,
                                                        ),
                                                        title: const Text(
                                                          'Call Agent',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        onTap: () =>
                                                            launchUrlString(
                                                                'tel:09072026425'),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        leading: const Icon(
                                                          Iconsax.message,
                                                          size: 25,
                                                          color: Colors.green,
                                                        ),
                                                        title: const Text(
                                                          'Chat Support',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        onTap: () =>
                                                            Get.to(ChatScreen(
                                                          user: user,
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                        ),
                                        child: Text(
                                          'Contact Us',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            }
          }),
    );
  }
}
