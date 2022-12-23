import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/screens/signInScreen.dart';
import '../../Widget/component.dart';
import '../controller/auth_controller.dart';

class ForgetPassword extends ConsumerWidget {
  ForgetPassword({Key key}) : super(key: key);
  TextEditingController emailController = TextEditingController();

  void resetPassword(WidgetRef ref) {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      showErrorToast('Please enter your email');
    } else {
      // ProductService().resetPwd(email.text.trim());
      ref.read(authtControllerProvider).resetPwd(email);

      showToast('Email sent');
      Get.to(() => SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: white,
        backgroundColor: secColor,
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
                controller: emailController,
                cursorColor: mainColor,
                decoration: InputDecoration(
                  hintText: 'Email address',
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
                  resetPassword(ref);
                }),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
