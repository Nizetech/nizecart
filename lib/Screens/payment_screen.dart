import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nizecart/botton_nav.dart';
import 'package:nizecart/products/product_controller.dart';
import '../Widget/component.dart';
import '../keys/keys.dart';
// import 'package:flutterwave/flutterwave.dart';

class PaymentMethod extends ConsumerStatefulWidget {
  // final int totalAmount;
  // final int total;
  // final String shippingFee;
  final Map data;
  PaymentMethod({Key key, this.data}) : super(key: key);

  @override
  ConsumerState<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends ConsumerState<PaymentMethod> {
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

  final formatter = intl.NumberFormat.decimalPattern();

  // PayStack Integration

  String publicKeyTest = 'pk_test_52197b2afc4c27f4491282296d1a848bea6794f9';

  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
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

  chargeCard() async {
    var charge = Charge()
      ..amount = widget.data['shippingFee'] != ''
          ? widget.data['total']
          : widget.data['totalAmount']
      // 100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
      ..putCustomField(
          'custom_id',
          getRandomString(
              8)) //to pass extra parameters to be retrieved on the response from Paystack
      ..email = email;

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    //check if the response is true or not
    if (response.status != true) {
      ref.read(productControllerProvider).orders(
          username: name,
          title: title,
          quantity: quantity,
          totalAmount: widget.data['totalAmount'],
          phoneNumber: '',
          address: widget.data['address'],
          productDetails: cartItems);
      //you can send some data from the response to an API or use webhook to record the payment on a database

      showToast('Payment was successful!!!');
      Get.to(BottomNav());
    } else {
      //the payment wasn't successsful or the user cancelled the payment
      showErrorToast('Payment Failed!!!');
    }
  }

  static var box = Hive.box('name');

  String name = box.get('displayName');
  String email = box.get('email');
  String title = box.get('title');
  int quantity = box.get('quantity');
  List cartItems = box.get('cart', defaultValue: []);

  //Add a method to make the flutter wave payment
  //This Method includes all the values needed to create the Flutterwave Instance
  // void _makeFlutterwavePayment(
  //     {BuildContext context,
  //     String fullname,
  //     String phone,
  //     String email,
  //     String amount}) async {
  //   try {
  //     Flutterwave flutterwave = Flutterwave.forUIPayment(
  //         //the first 10 fields below are required/mandatory
  //         context: this.context,
  //         fullName: fullname,
  //         phoneNumber: phone,
  //         email: email,
  //         amount: amount,
  //         //Use your Public and Encription Keys from your Flutterwave account on the dashboard
  //         encryptionKey: "FLWSECK_TESTcc5d33c6963a",
  //         publicKey: "FLWPUBK_TEST-5440b97b8cee96f460db958b2e1064be-X",
  //         currency: FlutterwaveCurrency.NGN,
  //         txRef: DateTime.now().toIso8601String(),
  //         //Setting DebugMode below to true since will be using test mode.
  //         //You can set it to false when using production environment.
  //         isDebugMode: false,
  //         //configure the the type of payments that your business will accept
  //         acceptCardPayment: true,
  //         acceptUSSDPayment: true,
  //         acceptBankTransfer: true,
  //         acceptAccountPayment: true,
  //         acceptFrancophoneMobileMoney: false,
  //         acceptGhanaPayment: false,
  //         acceptMpesaPayment: false,
  //         acceptRwandaMoneyPayment: false,
  //         acceptUgandaPayment: false,
  //         acceptZambiaPayment: false);

  //     final response = await flutterwave.initializeForUiPayments();
  //     if (response == null) {
  //       print("Transaction Failed");
  //     } else {
  //       if (response.status == "Transaction successful") {
  //         print(response.data);
  //         print(response.message);
  //       } else {
  //         print(response.message);
  //       }
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.data['shippingFee']);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Payment Method',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
              height: MediaQuery.of(context).size.height * .1,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
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
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(
                  value: 0,
                  groupValue: enable,
                  activeColor: mainColor,
                  onChanged: (val) {
                    change(val);
                  },
                ),
                title: const Text(
                  'Pay with Card',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
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
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(
                  value: 1,
                  groupValue: enable,
                  activeColor: mainColor,
                  onChanged: (val) {
                    change(val);
                  },
                ),
                title: const Text(
                  'Cash on delivery',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .17,
            ),
            Container(
                width: double.infinity,
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
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
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // enable == 0
                        widget.data['shippingFee'] != ''
                            ? Text(
                                'Shipping',
                                style: TextStyle(fontSize: 16),
                              )
                            : SizedBox(),
                        widget.data['shippingFee'] != ''
                            ? Text(
                                '₦ ${widget.data['shippingFee']}',
                                // formatter.format(shippingFee),
                                style: TextStyle(fontSize: 16),
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
                        widget.data['shippingFee'] != ''
                            ? Text(
                                // '₦ ${total}',
                                '₦ ' + formatter.format(widget.data['total']),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                '₦ ' +
                                    formatter
                                        .format(widget.data['totalAmount']),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: 'Proceed to Payment',
                      onPressed: () {
                        // Get.to(PaymentMethod());
                        // ref.read(productControllerProvider).orders(
                        //       username: name,
                        //       title: title,
                        //       quantity: quantity,
                        //       totalAmount: widget.data['totalAmount'],
                        //       phoneNumber: '',
                        //       address: widget.data['address'],
                        //     );
                        // print(widget.data['totalAmount']);
                        // _makeFlutterwavePayment(
                        //   context: context,
                        //   fullname: name,
                        //   phone: '09072026425',
                        //   email: email,
                        //   amount: widget.data['totalAmount'].toString(),
                        // );

                        chargeCard();
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
