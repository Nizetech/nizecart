import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Models/productService.dart';

import '../Widget/component.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({Key key}) : super(key: key);
  TextEditingController nPwd = TextEditingController();
  TextEditingController cPwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          'Account',
          style: TextStyle(fontSize: 20),
        ),
        leadingWidth: 10,
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: nPwd,
                obscureText: false,
                obscuringCharacter: '*',
                cursorColor: mainColor,
                decoration: InputDecoration(
                  labelText: 'New password',
                  hintText: 'Enter New password',
                  // labelStyle: TextStyle(fontSize: 18),
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
              height: 30,
            ),
            TextField(
                controller: cPwd,
                // obscureText: true,
                // obscuringCharacter: '*',
                cursorColor: mainColor,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  hintText: 'Confirm password',
                  // labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  isDense: true,

                  prefixIconColor: mainColor,
                  iconColor: mainColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: mainColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: mainColor)),
                )),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                text: "Change Password",
                onPressed: () async {
                  loading('Adding Product...');
                  // print(storedImage);
                  if (nPwd.text == cPwd.text) {
                    ProductService().changePassword(cPwd.text);
                    Navigator.pop(context);
                    print(cPwd.text);
                    showToast('Password changed successfully');
                  } else {
                    showErrorToast('Password does not match');
                    Get.back();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
