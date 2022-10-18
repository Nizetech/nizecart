import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Models/user_model.dart';
import 'package:nizecart/Screens/checkout_screen.dart';
import 'package:nizecart/Screens/map_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/services/service_controller.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  Map user;
  String location;
  final int totalAmount;

  DeliveryScreen({
    Key key,
    this.totalAmount,
    this.user,
    this.location,
  }) : super(key: key);

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController post = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<Map<dynamic, dynamic>> userDetail;
  // Future<Map> user;
  // UserModel user;

  User user;
  Position currentPosition;
  String currentAddress;
  String countryName = 'United State';
  String userAddress = '';

  // static var box = Hive.box('name');
  // String location = box.get('location', defaultValue: '');
  bool isLocation = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    ref.read(serviceControllerProvider).getUserAddress().then((value) {
      if (mounted) {
        setState(() {
          userAddress = value;
        });
      }
    });
    userDetail;

    address.text = widget.location ?? widget.user['address'];
    email.text = user.email;
    name.text = user.displayName;
    country.text = widget.user['country'] ?? countryName;
    city.text = widget.user['city'];
    post.text = widget.user['postCode'];
    phone.text = widget.user['phoneNumber'];
    log('my userAddress: ${user.email}');

    super.initState();
  }

  static var box = Hive.box('name');
  Map userData = box.get('userData', defaultValue: {});
  @override
  Widget build(BuildContext context) {
    log('my user: ${userData}');
    userData.addAll({
      'postCode': widget.user['postCode'],
      'phoneNumber': widget.user['phoneNumber'],
      'city': widget.user['city'],
      'country': widget.user['country'],
    }
        // widget.user['phoneNumber'],
        );
    box.put('userData', userData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery'),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  print('tapped');
                  log('my userAddress: $userData');

                  Get.to(MapScreen(
                    loc: userAddress,
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.my_location_rounded,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Select Delivery Location',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: name,
                label: 'Name',
                enable: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: email,
                label: 'Email',
                enable: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: country,
                label: 'Country',

                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        widget.user['country'] != ''
                            ? countryName
                            : country.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                countryName = country.displayNameNoCountryCode;
                              });
                            });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                // enable: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: address,
                label: 'Address',
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: city,
                      label: 'Town/city',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: post,
                      label: 'Postcode',
                      keyboard: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: phone,
                label: 'Phone Number',
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  if (country.text.trim().isEmpty ||
                      address.text.trim().isEmpty ||
                      city.text.trim().isEmpty ||
                      phone.text.trim().isEmpty ||
                      post.text.trim().isEmpty) {
                    toast('Please fill all fields');
                    return;
                  } else {
                    loader();
                    await ref.read(authtControllerProvider).updateDelivery(
                          country: country.text.trim(),
                          post: post.text.trim(),
                          address: address.text.trim(),
                          city: city.text.trim(),
                          phone: phone.text.trim(),
                        );
                    Get.to(
                      CheckOutScreen(totalAmount: widget.totalAmount),
                    );
                  }
                },
                text: 'Proceed to checkout',
              )
            ],
          ),
        ),
      ),
    );
  }
}
