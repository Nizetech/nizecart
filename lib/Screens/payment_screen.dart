import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nizecart/Models/payment.dart';
import 'package:nizecart/Screens/success_screen.dart';
// import 'package:nizecart/botton_nav.dart';
import 'package:nizecart/products/product_controller.dart';
import 'package:nizecart/services/service_controller.dart';
import '../Widget/component.dart';
import '../keys/keys.dart';
// import 'package:flutterwave/flutterwave.dart';

class PaymentMethod extends ConsumerStatefulWidget {
  final Map data;
  PaymentMethod({Key key, this.data}) : super(key: key);

  @override
  ConsumerState<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends ConsumerState<PaymentMethod> {
  static var box = Hive.box('name');

  List cartItems = box.get('cart', defaultValue: []);

  int enable = 0;
  void change(dynamic val) {
    setState(() {
      enable = val;
      // if (enable == 0) {
      //   delivery.add('Door Delivery');
      // } else {
      //   delivery.add('Pickup Station');
      // }
    });
  }

  User user;

  final formatter = intl.NumberFormat.decimalPattern();

//   // PayStack Integration

// //   String publicKeyTest = 'pk_test_52197b2afc4c27f4491282296d1a848bea6794f9';

//   final plugin = PaystackPlugin();
//   @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    // plugin.initialize(publicKey: PayStackKey);

    super.initState();
  }

//   //used to generate a unique reference for payment
//   String _getReference() {
//     var platform = (Platform.isIOS) ? 'iOS' : 'Android';
//     final thisDate = DateTime.now().millisecondsSinceEpoch;
//     return 'ChargedFrom${platform}_$thisDate';
//   }

//   //async method to charge users card and return a response

// // Test Card
//   ///Bank Auth Simulation(reusable)
// //     4084 0800 0000 0409
// //     (EXPIRY
// //   09/23,
// //   (CVV
// //    000),

//   chargeCard() async {
//     var charge = Charge()
//       ..amount = widget.data['shippingFee'] != ''
//           ? widget.data['total'] * 100
//           : widget.data['totalAmount'] * 100
//       // 100 //the money should be in kobo hence the need to multiply the value by 100
//       ..reference = _getReference()
//       ..putCustomField(
//         'custom_id',
//         getRandomString(8),
//       ) //to pass extra parameters to be retrieved on the response from Paystack
//       ..email = email;

//     CheckoutResponse response = await plugin.checkout(
//       context,
//       method: CheckoutMethod.card,
//       charge: charge,
//     );
//     if (response.status == true) {
//       ref.read(productControllerProvider).orders(
//             username: widget.data['firstName'] + ' ' + widget.data['last_name'],
//             quantity: quantity,
//             totalAmount: widget.data['totalAmount'],
//             phoneNumber: widget.data['phoneNumber'],
//             address: widget.data['address'],
//             city: widget.data['city'],
//             email: widget.data['email'],
//             country: widget.data['country'],
//             postCode: widget.data['postCode'],
//             productDetails: cartItems,
//           );
//       //you can send some data from the response to an API or use webhook to record the payment on a database
//       setState(() {});
//       Get.to(const SuccessPage());
//       cartItems.clear();
//       box.put('cart', cartItems);
//     } else {
//       //the payment wasn't successsful or the user cancelled the payment
//       toast('Payment Failed!!!');
//       return;
//     }
//   }

// Flutter wave Test Card
// Card No 5531886652142950
//Cvv 564
//Pin 3310
// Exp 09/32
// OTP 12345

  String email = box.get('email');
  String title = box.get('title');
  int quantity = box.get('quantity');

  @override
  Widget build(BuildContext context) {
    bool isShipping = widget.data['shippingFee'] != '';
    print('runtime type ${widget.data['total']}');
    print('runtime type ${widget.data['totalAmount']}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Payment Method',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey.withOpacity(.2),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Choose Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Container(
          //   width: double.infinity,
          //   margin: EdgeInsets.only(left: 15, right: 15, top: 10),
          //   padding: EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     color: white,
          //     border: Border.all(
          //       color: Colors.grey[200],
          //     ),
          //     borderRadius: BorderRadius.circular(10),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey.withOpacity(.2),
          //         blurRadius: 5,
          //         offset: Offset(0, 3),
          //       )
          //     ],
          //   ),
          //   child: ListTile(
          //     contentPadding: EdgeInsets.zero,
          //     leading: Radio(
          //       value: 0,
          //       groupValue: enable,
          //       activeColor: mainColor,
          //       onChanged: (val) {
          //         setState(() {
          //           enable = val;
          //           enable = 0;
          //         });
          //       },
          //     ),
          //     title: const Text(
          //       'Pay with Paystack',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     subtitle: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Image.asset(
          //           'assets/payment_method.png',
          //           fit: BoxFit.cover,
          //           width: double.infinity,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[200],
              ),
              borderRadius: BorderRadius.circular(10),
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Radio(
                value: 0,
                groupValue: enable,
                activeColor: mainColor,
                onChanged: (val) {
                  setState(() {
                    enable = val;
                    // enable = 0;
                  });
                },
              ),
              title: const Text(
                'Pay with Card',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/payment_method.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[200],
              ),
              borderRadius: BorderRadius.circular(10),
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Radio(
                value: 1,
                groupValue: enable,
                activeColor: mainColor,
                onChanged: (val) {
                  setState(() {
                    enable = val;
                    enable = 1;
                  });
                },
              ),
              title: const Text(
                'Cash on delivery',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sub Total',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '₦ ' + formatter.format(widget.data['totalAmount']),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // enable == 0
                    isShipping
                        ? const Text(
                            'Shipping',
                            style: TextStyle(fontSize: 16),
                          )
                        : SizedBox(),
                    isShipping
                        ? Text(
                            '₦ ${widget.data['shippingFee']}',
                            // formatter.format(shippingFee),
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 16),
                    ),
                    isShipping
                        ? Text(
                            // '₦ ${total}',
                            '₦ ' + formatter.format(widget.data['total']),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            '₦ ' + formatter.format(widget.data['totalAmount']),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          )
                  ],
                ),
                SizedBox(height: 10),
                CustomButton(
                  text: 'Order',
                  onPressed: () {
                    // enable == 0
                    // ? ref.read(productControllerProvider).payStackPay(
                    //     context: context,
                    //     name: user.displayName,
                    //     email: widget.data['email'],
                    //     amount: isShipping
                    //         ? widget.data['total'] * 100
                    //         : widget.data['totalAmount'] * 100)
                    // ? () {}
                    // :
                    enable == 0
                        ? ref
                            .read(productControllerProvider)
                            .payWithFlutterWave(
                              username: user.displayName,
                              amount: isShipping
                                  ? widget.data['total'].toString()
                                  : widget.data['totalAmount'].toString(),
                              quantity: quantity,
                              totalAmount: widget.data['totalAmount'],
                              phoneNumber: widget.data['phoneNumber'],
                              address: widget.data['address'],
                              lga: widget.data['lga'],
                              email: widget.data['email'],
                              state: widget.data['state'],
                              postCode: widget.data['postCode'],
                              productDetails: cartItems,
                              context: context,
                            )
                        : ref.read(productControllerProvider).orders(
                              username: user.displayName,
                              quantity: quantity,
                              totalAmount: widget.data['totalAmount'],
                              phoneNumber: widget.data['phoneNumber'],
                              address: widget.data['address'],
                              lga: widget.data['lga'],
                              email: widget.data['email'],
                              state: widget.data['state'],
                              postCode: widget.data['postCode'],
                              productDetails: cartItems,
                            );
                    ref.read(serviceControllerProvider).sendMessage(
                      token: widget.data['token'],
                      message: {
                        'title': 'You Order has been placed on Nizecart',
                        'body': 'Your Order have been placed pending shipping',
                        'id': widget.data['productID'],
                        'type': 'Order',
                        'name': user.displayName,
                        // 'uid': widget.data['uid'],
                        'date': FieldValue.serverTimestamp(),
                      },
                    );
                    log('just sent');
                    log('my token ${widget.data['token']}');
                    // Get.to(SuccessPage());
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
