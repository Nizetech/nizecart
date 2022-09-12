import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nizecart/products/product_controller.dart';
import '../Widget/component.dart';

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

  String publicKeyTest = 'pk_test_d42841af2d444e404898c6f7cb5da66c24ac2064';

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

  chargeCard() async {
    var charge = Charge()
      ..amount = 10000 *
          100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
      ..putCustomField('custom_id',
          '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
      ..email = 'fortunepraise97@email.com';

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    //check if the response is true or not
    if (response.status == true) {
      //you can send some data from the response to an API or use webhook to record the payment on a database

      showToast('Payment was successful!!!');
    } else {
      //the payment wasn't successsful or the user cancelled the payment
      showErrorToast('Payment Failed!!!');
    }
  }

  static var box = Hive.box('name');

  String name = box.get('displayName');
  String title = box.get('title');
  int quantity = box.get('quantity');

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
          Spacer(),
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
                                  formatter.format(widget.data['totalAmount']),
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
                      ref.read(productControllerProvider).orders(
                            username: name,
                            title: title,
                            quantity: quantity,
                            totalAmount: widget.data['totalAmount'],
                            phoneNumber: 'empty',
                            address: widget.data['address'],
                          );
                      print(widget.data['totalAmount']);
                      print(name);
                      print(title);
                      print(quantity);
                      print(widget.data['address']);
                      chargeCard();
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
