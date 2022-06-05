import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Models/productService.dart';
import 'package:nizecart/Widget/bottonNav.dart';
import '../Widget/component.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: white,
        backgroundColor: secColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Recover Password',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Spacer(),
            Text(
              "Please type in your email.\nWe will send you a link to change the password.",
              style: TextStyle(
                color: Color(0xcc000000).withOpacity(.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            TextField(
                controller: email,
                cursorColor: mainColor,
                decoration: InputDecoration(
                  hintText: 'Email address',
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
            SizedBox(height: 30),
            CustomButton(
                text: 'Submit',
                onPressed: () {
                  if (email.text.isEmpty) {
                    showToast('Please enter your email');
                    ProductService().resetPwd(email.text);
                  } else {
                    showToast('Email sent');
                    // Get.to(BottomNav());
                  }
                }),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
