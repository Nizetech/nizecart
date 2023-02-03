import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../Auth/controller/auth_controller.dart';
import '../../../Widget/component.dart';

class ChangeDisplayName extends ConsumerStatefulWidget {
  Map user;
  ChangeDisplayName({Key key, this.user}) : super(key: key);

  @override
  ConsumerState<ChangeDisplayName> createState() => _ChangeDisplayNameState();
}

class _ChangeDisplayNameState extends ConsumerState<ChangeDisplayName> {
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    name.text = widget.user['displayName'];
    super.initState();
  }

  String init = '';

// @override
  void updateDisplayName(WidgetRef ref, BuildContext context) {
    if (name.text != null) {
      ref.read(authtControllerProvider).ChangeDisplayName(name.text);
      print('name changed===${name.text}');
      Navigator.of(context).pop();
      showToast('Password changed successfully');
    } else {
      showErrorToast('Password does not match');
      // Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    log('displayName===${name.text}');
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
                controller: name,
                obscureText: false,
                textCapitalization: TextCapitalization.words,
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
                  updateDisplayName(ref, context);
                }),
          ],
        ),
      ),
    );
  }
}
