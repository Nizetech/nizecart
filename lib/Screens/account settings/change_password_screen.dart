import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../Auth/controller/auth_controller.dart';
import '../../Widget/component.dart';

class ChangePassword extends ConsumerWidget {
  ChangePassword({Key key}) : super(key: key);
  TextEditingController nPwd = TextEditingController();
  TextEditingController cPwd = TextEditingController();

  String init = '';
  void updatePassword(WidgetRef ref, BuildContext context) {
    if (nPwd.text != null) {
      ref.read(authtControllerProvider).changePassword(nPwd.text.trim());
      nPwd.text = init;
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
          'Change Password',
          style: TextStyle(fontSize: 20),
        ),
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
                onPressed: () {
                  updatePassword(ref, context);
                }),
          ],
        ),
      ),
    );
  }
}
