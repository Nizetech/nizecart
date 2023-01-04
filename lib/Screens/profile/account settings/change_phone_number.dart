import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../Auth/controller/auth_controller.dart';
import '../../../Widget/component.dart';

class ChangePhoneNumber extends ConsumerStatefulWidget {
  final Map user;
  ChangePhoneNumber({Key key, this.user}) : super(key: key);

  @override
  ConsumerState<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends ConsumerState<ChangePhoneNumber> {
  TextEditingController phone = TextEditingController();
  @override
  void initState() {
    phone.text = widget.user['phone'];
    super.initState();
  }

  void updatePhoneNumber(WidgetRef ref, BuildContext context) {
    if (phone.text != null) {
      ref.read(authtControllerProvider).changePhoneNumber(phone.text);

      Navigator.of(context).pop();
      showToast('Phone Number changed successfully');
    } else {
      showErrorToast('Error occurred!!');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Change Phone Number',
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
                  hintText: 'Enter New Phone Number',
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
                text: "Change Phone Number",
                onPressed: () {
                  updatePhoneNumber(ref, context);
                }),
          ],
        ),
      ),
    );
  }
}
