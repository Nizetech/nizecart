import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../Auth/controller/auth_controller.dart';
import '../../../Widget/component.dart';

class ChangePhoneNumber extends ConsumerWidget {
  final Map user;
  ChangePhoneNumber({Key key, this.user}) : super(key: key);
  TextEditingController phone = TextEditingController();

  void updatePhoneNumber(WidgetRef ref, BuildContext context) {
    if (phone.text != null) {
      ref.read(authtControllerProvider).changePhoneNumber(phone.text);

      Navigator.of(context).pop();
      showToast('Password changed successfully');
    } else {
      showErrorToast('Password does not match');
      // Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Change Display Name',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
                controller: phone,
                obscureText: false,
                cursorColor: mainColor,
                decoration: InputDecoration(
                  hintText: 'Enter New Dispaly Name',
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
            SizedBox(
              height: 20,
            ),
            CustomButton(
                text: "Change Display Name",
                onPressed: () {
                  updatePhoneNumber(ref, context);
                }),
          ],
        ),
      ),
    );
  }
}
