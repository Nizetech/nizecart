import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Screens/account%20settings/change_display_name.dart';
import 'package:nizecart/Screens/account%20settings/change_password_screen.dart';
import 'package:nizecart/Widget/component.dart';

class AccountSettings extends ConsumerStatefulWidget {
  final Map user;
  const AccountSettings({Key key, this.user}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSettingsState();
}

class _AccountSettingsState extends ConsumerState<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Account Settings',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: white,
      body: Column(children: [
        SizedBox(height: 20),
        AccountListTile(
          text: 'Change Display Name',
          icon: Icon(
            Iconsax.lock,
            color: mainColor,
          ),
          onTap: () => Get.to(ChangeDisplayName()),
        ),
        const AccountListTile(
          text: 'Change Phone Number',
          icon: Icon(
            Iconsax.lock,
            color: mainColor,
          ),
          // onTap: () => Get.to(ChangePassword()),
        ),
        AccountListTile(
          text: 'Change password',
          icon: Icon(
            Iconsax.lock,
            color: mainColor,
          ),
          onTap: () => Get.to(ChangePassword()),
        ),
        AccountListTile(
            text: 'Delete Account',
            icon: const Icon(
              Iconsax.profile_delete,
              color: mainColor,
            ),
            onTap: () {
              Get.dialog(
                AlertDialog(
                  content:
                      Text('Are you sure you want  to delete you account?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        ref.read(authtControllerProvider).deleteAccount();
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'yes',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            })
      ]),
    );
  }
}
