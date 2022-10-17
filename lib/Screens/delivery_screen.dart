import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Models/user_model.dart';
import 'package:nizecart/Screens/checkout_screen.dart';
import 'package:nizecart/Screens/map_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/services/service_controller.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  Map user;
  final int totalAmount;
  DeliveryScreen({Key key, this.totalAmount, this.user}) : super(key: key);

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
  String userAddress = '';
  // UserModel user;

  User user;
  Position currentPosition;
  String currentAddress;
  String countryName = 'United State';

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
      print(' my Cuurent position $currentPosition');
      print('my current address $currentAddress');

      getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  getAddressFromLatLng() async {
    try {
      // to translate latititude and longitude into an address
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        currentAddress =
            "${place.street}, ${place.administrativeArea}, ${place.subLocality}, ${place.name}, ${place.subThoroughfare}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
      log(currentAddress);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    // user = ref.read(authtControllerProvider).getUserDetails();
    userDetail;

    address.text = widget.user['address'];
    email.text = user.email;
    name.text = user.displayName;
    country.text = widget.user['country'] ?? countryName;
    city.text = widget.user['city'];
    post.text = widget.user['postCode'];
    address.text = widget.user['address'];
    phone.text = widget.user['phoneNumber'];
    print('my user: ${widget.user}');

    ref.read(serviceControllerProvider).getUserAddress().then((value) {
      if (mounted) {
        setState(() {
          userAddress = value;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('my user: ${user.email}');

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
                  print('tapped me $userAddress');
                  // Get.to(MapScreen());
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
