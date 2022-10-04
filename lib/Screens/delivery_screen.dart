import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Models/user_model.dart';
import 'package:nizecart/Screens/checkout_screen.dart';
import 'package:nizecart/Screens/map_screen.dart';
import 'package:nizecart/Widget/component.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  final int totalAmount;
  DeliveryScreen({Key key, this.totalAmount}) : super(key: key);

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController post = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  Future<Map<dynamic, dynamic>> userDetail;
  UserModel user;
  String userAddress = '';

  @override
  void initState() {
    
    userDetail;
    
    // address.text = user.address;
    // name.text = user.firstName;
    // country.text = user.country;
    // city.text = user.city;
    // post.text = user.postCode;
    // email.text = user.email;
    // phone.text = user.phoneNumber;
    print(user);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery'),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder<Object>(
              future:  ref.read(authtControllerProvider).getUserDetails(),
              builder: (context, snapshot) {
                print('my details $snapshot');
                if (!snapshot.hasData) {
                  return loader();
                } else {
                 userDetail = snapshot.data;
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Get.to(MapScreen()),
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
                        hint: 'Name',
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: country,
                        hint: 'Country',
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: address,
                        hint: 'Address',
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: city,
                              hint: 'Town/city',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              controller: post,
                              hint: 'Postcode',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: phone,
                        hint: 'Phone Number',
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        onPressed: () => Get.to(
                          CheckOutScreen(totalAmount: widget.totalAmount),
                        ),
                        text: 'Proceed to checkout',
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
