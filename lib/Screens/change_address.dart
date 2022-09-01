import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import '../Widget/component.dart';

class ChangeAddress extends ConsumerWidget {
  ChangeAddress({Key key}) : super(key: key);
  TextEditingController address = TextEditingController();

  String init = '';
  void updateAddress(WidgetRef ref) {
    if (address.text != null) {
      ref.read(authtControllerProvider).changeAddress(address.text.trim());
      address.text = init;
      Get.back();
      showToast('Address changed successfully');
    } else {
      showErrorToast('Could not change address');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text(
          'Change Address',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leadingWidth: 10,
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: address,
                obscureText: false,
                cursorColor: mainColor,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter New Address',
                  filled: true,
                  isDense: true,
                  prefixIconColor: mainColor,
                  iconColor: mainColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                )),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                text: "Change Address",
                onPressed: () {
                  updateAddress(ref);
                }),
          ],
        ),
      ),
    );
  }
}
