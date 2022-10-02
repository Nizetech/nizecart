import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/botton_nav.dart';
import 'package:nizecart/keys/keys.dart';
import 'package:nizecart/products/product_controller.dart';

class PayWithPaystack extends ConsumerStatefulWidget {
  final int amount;
  final String email;
  final String name;
  final String title;
  final int quantity;
  final String phoneNumber;
  final List cartItems;
  final int totalAmount;
  final String address;
  PayWithPaystack({
    Key key,
    this.amount,
    this.address,
    this.cartItems,
    this.email,
    this.name,
    this.phoneNumber,
    this.quantity,
    this.title,
    this.totalAmount,
  }) : super(key: key);

  @override
  ConsumerState<PayWithPaystack> createState() => _PayWithPaystackState();
}

class _PayWithPaystackState extends ConsumerState<PayWithPaystack> {
  // PayStack Integration

  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: PayPalKey);
    super.initState();
  }

  //used to generate a unique reference for payment
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  //async method to charge users card and return a response

// Test Card
  ///Bank Auth Simulation(reusable)
//     4084 0800 0000 0409
//     (EXPIRY
//   09/23,
//   (CVV
//    000),

  payWithPayPal() async {
    var charge = Charge()
      ..amount = widget.amount
      // = widget.data['shippingFee'] != ''
      //     ? widget.data['total']
      //     : widget.data['totalAmount']
      // 100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
      ..putCustomField(
          'custom_id',
          getRandomString(
              8)) //to pass extra parameters to be retrieved on the response from Paystack
      ..email = widget.email;

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    //check if the response is true or not
    if (response.status != true) {
      ref.read(productControllerProvider).orders(
            username: widget.name,
            title: widget.title,
            quantity: widget.quantity,
            totalAmount: widget.totalAmount,
            //  widget.data['totalAmount'],
            phoneNumber: widget.phoneNumber,
            address: widget.address,
            // widget.data['address'],
            productDetails: widget.cartItems,
          );
      //you can send some data from the response to an API or use webhook to record the payment on a database

      showToast('Payment was successful!!!');
      Get.to(BottomNav());
    } else {
      //the payment wasn't successsful or the user cancelled the payment
      showErrorToast('Payment Failed!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return payWithPayPal();
  }
}

// PayStack Integration

// String publicKeyTest = 'pk_test_52197b2afc4c27f4491282296d1a848bea6794f9';

// final plugin = PaystackPlugin();

// @override
// void initState() {
//   plugin.initialize(publicKey: publicKeyTest);
//   super.initState();
// }

// //used to generate a unique reference for payment
// String _getReference() {
//   var platform = (Platform.isIOS) ? 'iOS' : 'Android';
//   final thisDate = DateTime.now().millisecondsSinceEpoch;
//   return 'ChargedFrom${platform}_$thisDate';
// }

// //async method to charge users card and return a response

// // Test Card
// ///Bank Auth Simulation(reusable)
// //     4084 0800 0000 0409
// //     (EXPIRY
// //   09/23,
// //   (CVV
// //    000),

// chargeCard() async {
//   var charge = Charge()
//     ..amount = widget.data['shippingFee'] != ''
//         ? widget.data['total']
//         : widget.data['totalAmount']
//     // 100 //the money should be in kobo hence the need to multiply the value by 100
//     ..reference = _getReference()
//     ..putCustomField(
//         'custom_id',
//         getRandomString(
//             8)) //to pass extra parameters to be retrieved on the response from Paystack
//     ..email = email;

//   CheckoutResponse response = await plugin.checkout(
//     context,
//     method: CheckoutMethod.card,
//     charge: charge,
//   );

//   //check if the response is true or not
//   if (response.status != true) {
//     ref.read(productControllerProvider).orders(
//           username: name,
//           title: title,
//           quantity: quantity,
//           totalAmount: widget.data['totalAmount'],
//           phoneNumber: '',
//           address: widget.data['address'],
//           productDetails: cartItems,
//         );
//     //you can send some data from the response to an API or use webhook to record the payment on a database

//     showToast('Payment was successful!!!');
//     Get.to(BottomNav());
//   } else {
//     //the payment wasn't successsful or the user cancelled the payment
//     showErrorToast('Payment Failed!!!');
//   }
// }
