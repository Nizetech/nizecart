import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Screens/map_screen.dart';
import 'package:nizecart/Screens/payment_screen.dart';
import '../Widget/component.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  final int totalAmount;
  CheckOutScreen({Key key, this.totalAmount}) : super(key: key);

  @override
  ConsumerState<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  int enable = 1;
  final String shippingFee = '3109';

  final formatter = intl.NumberFormat.decimalPattern();
  int get total {
    int total = 0;
    total += widget.totalAmount + int.parse(shippingFee);
    return total;
  }

// final Geolocator geolocator = Geolocator.getCurrentPosition(desiredAccuracy: Loca);

  Position _currentPosition;
  String _currentAddress;

  // getCurrentLocation() {
  //   Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.best,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     setState(() {
  //       currentPosition = position;
  //     });
  //     print(position);
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
      print(_currentPosition);
      print(_currentAddress);

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      // to translate latititude and longitude into an address
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.street}, ${place.administrativeArea}, ${place.subLocality}, ${place.name}, ${place.subThoroughfare}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  List<String> delivery = [];

  void change(dynamic val) {
    setState(() {
      enable = val;
      if (enable == 0) {
        // delivery.add('Door Delivery');
        box.put('method', 'Door Delivery');
      } else {
        box.put('method', 'Pickup Station');
      }
    });
  }

  static var box = Hive.box('name');

  Future<void> refresh() async => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: white,
      body: RefreshIndicator(
        onRefresh: refresh,
        color: mainColor,
        child:
            // print(snapshot.data['address']);
            // print('Here i  am ${snapshot.data}');

            FutureBuilder(
                future: ref.read(authtControllerProvider).getUserDetails(),
                builder: (context, snapshot) {
                  Map<String, dynamic> data = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.grey.withOpacity(.2),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              _getCurrentLocation();
                              print('this is me');
                            },
                            child: Text(
                              'Select Delivery Method',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
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
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey[200],
                          ),
                          borderRadius: BorderRadius.circular(10),
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
                            'Door Delivery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivered within 5 working days',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 5),
                              RichText(
                                  text: TextSpan(
                                text: 'Delivery Fee: ',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                                children: [
                                  TextSpan(
                                    text: '₦' +
                                        formatter
                                            .format(int.parse(shippingFee))
                                            .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(
                            color: Colors.grey[200],
                          ),
                          borderRadius: BorderRadius.circular(10),
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
                            ListTile(
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
                                'Pickup Station',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: const Text(
                                'Delivered within 5 working days',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Divider(
                                // thickness: 2,
                                ),
                            const Text(
                              'Select Pickup Station',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Summary',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 20),
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
                                  '₦ ' + formatter.format(widget.totalAmount),
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
                                enable == 0
                                    ? Text(
                                        'Shipping',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    : SizedBox(),
                                enable == 0
                                    ? Text(
                                        '₦ ${shippingFee}',
                                        // formatter.format(shippingFee),
                                        style: TextStyle(
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
                                enable == 0
                                    ? Text(
                                        // '₦ ${total}',
                                        '₦ ' + formatter.format(total),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: mainColor,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        '₦ ' +
                                            formatter
                                                .format(widget.totalAmount),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: mainColor,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                            SizedBox(height: 10),
                            CustomButton(
                                text: 'Proceed to Payment',
                                onPressed: () {
                                  data.addAll({
                                    'total': total,
                                    'shippingFee':
                                        enable == 0 ? shippingFee : '',
                                    'totalAmount': widget.totalAmount,
                                  });

                                  Get.to(PaymentMethod(data: data));
                                }),
                          ],
                        ),
                      )
                    ],
                  );
                }),
      ),
    );
  }
}
