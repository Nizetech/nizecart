import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Auth/screens/signInScreen.dart';
import 'package:nizecart/Screens/profile/account_screen.dart';
import 'package:nizecart/Screens/account%20settings/account_settings.dart';
import 'package:nizecart/Screens/profile/order_history.dart';
import 'package:nizecart/Screens/order_screen.dart';
import 'package:nizecart/Screens/profile/privacy_policy.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/chat/chat_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  static var box = Hive.box('name');
  bool isLocked = box.get('isLocked', defaultValue: false);
  final String email = box.get('email');
  final String displayName = box.get('displayName');
  String lName = box.get('lname');

  // void updateImage(ImageSource source) async {
  //   ImagePicker picker = ImagePicker();
  //   var file = await picker.pickImage(
  //     source: source,
  //     imageQuality: 30,
  //   );

  //   if (file != null) {
  //     ref.read(authtControllerProvider).updateProfileImage(
  //           File(file.path),
  //         );
  //     // Navigator.of(context).pop();
  //     Get.back();
  //     setState(() {});
  //     // user.reload();
  //   }
  //   return;
  // }
  void updateImage(
    ImageSource source,
  ) async {
    XFile pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 40);
    if (pickedFile != null) {
      CroppedFile croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressQuality: 50,
          cropStyle: CropStyle.circle,
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: false,
            ),
          ]);
      if (croppedFile != null) {
        // setState(() {
        //   storedImage = File(croppedFile.path);
        // });
        ref
            .read(authtControllerProvider)
            .updateProfileImage(File(croppedFile.path));
      } else {
        return null;
      }
    }
    setState(() {});
    Get.back();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // user.reload();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: SizedBox(),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: white,
      body: FutureBuilder(
          future: ref.read(authtControllerProvider).getUserDetails(),
          // stream: ref.read(authtControllerProvider).userDetails(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // print(snapshot.data['photoUrl']);

              Map user = snapshot.data;

              // print('My user ${user['photoUrl']}');
              String data = user == null ? '' : user['photoUrl'];

              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 200,
                              margin: const EdgeInsets.only(bottom: 50),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(40),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(40),
                                ),
                                child: Image.asset(
                                  'assets/shopping.jpg',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  colorBlendMode: BlendMode.darken,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              bottom: 50,
                              right: 0,
                              left: 0,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(40),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(.3),
                                      Colors.black.withOpacity(.5),
                                      secColor.withOpacity(.6),
                                      secColor,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    )),
                                child: GestureDetector(
                                  onTap: () => Get.dialog(Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: secColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: 230,
                                      width: 200,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          data == '' || data == null
                                              ? Icon(
                                                  Iconsax.user,
                                                  size: 70,
                                                  color: white,
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: data,
                                                    height: 230,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  child: Stack(children: [
                                    CircleAvatar(
                                      radius: 55,
                                      backgroundColor: Colors.grey[200],
                                      child: data == '' || data == null
                                          ? const Icon(
                                              Iconsax.user,
                                              size: 70,
                                              color: secColor,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(70),
                                              child: CachedNetworkImage(
                                                imageUrl: data,
                                                height: 140,
                                                width: 140,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!isLoggedIn) {
                                                Get.to(SignInScreen());
                                              } else {
                                                Get.dialog(
                                                  Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              'Change Profile Picture',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            TextButton.icon(
                                                              onPressed: () {
                                                                updateImage(
                                                                    ImageSource
                                                                        .gallery);
                                                              },
                                                              icon: const Icon(
                                                                  Iconsax
                                                                      .gallery),
                                                              label: const Text(
                                                                  'Choose from Gallery'),
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  secColor,
                                                                ),
                                                                foregroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            TextButton.icon(
                                                              onPressed:
                                                                  () async {
                                                                updateImage(
                                                                    ImageSource
                                                                        .camera);
                                                              },
                                                              icon: const Icon(
                                                                Iconsax.image,
                                                                size: 15,
                                                              ),
                                                              label: const Text(
                                                                'Choose from camera',
                                                              ),
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  secColor,
                                                                ),
                                                                foregroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  boxShadow: [
                                                    const BoxShadow(
                                                      blurRadius: 3,
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(75),
                                                  color: white),
                                              child: const Icon(
                                                Iconsax.camera,
                                                size: 23,
                                                color: secColor,
                                              ),
                                            ),
                                          ),
                                        ))
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Center(
                                  child: Column(
                                    children: [
                                      data == null
                                          ? SizedBox()
                                          : Text(
                                              '$displayName',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.blue[800],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                      data == null
                                          ? SizedBox()
                                          : Text(
                                              '$email',
                                              style: const TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 3,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Iconsax.user,
                                          color: mainColor,
                                        ),
                                        title: const Text(
                                          'Account settings',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.navigate_next_sharp),
                                        onTap: () => Get.to(AccountSettings(
                                          user: user,
                                        )),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        onTap: () {
                                          isLoggedIn
                                              ? Get.to(OrderScreen())
                                              : Get.to(SignInScreen());
                                        },
                                        leading: const Icon(
                                          Iconsax.shopping_bag,
                                          color: mainColor,
                                        ),
                                        title: const Text(
                                          'Orders',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.navigate_next_sharp),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Iconsax.finger_cricle,
                                          color: mainColor,
                                        ),
                                        title: const Text(
                                          'Biometrics',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Switch(
                                          trackColor: MaterialStateProperty.all(
                                              const Color(0xffD8D8D8)),
                                          activeColor: const Color(0xff34C759),
                                          value: isLocked,
                                          onChanged: (val) {
                                            LocalAuthentication()
                                                .authenticate(
                                                    localizedReason:
                                                        'Please authenticate to continue',
                                                    options:
                                                        const AuthenticationOptions(
                                                      biometricOnly: true,
                                                    ))
                                                .then((val) {
                                              if (val) {
                                                setState(() {
                                                  isLocked = !isLocked;
                                                });
                                                box.put('isLocked', isLocked);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Iconsax.info_circle,
                                          color: mainColor,
                                        ),
                                        title: const Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onTap: () => Get.to(PrivacyPolicy()),
                                        trailing:
                                            Icon(Icons.navigate_next_sharp),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Iconsax.message_question,
                                          color: mainColor,
                                        ),
                                        title: const Text(
                                          'Help',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: const Icon(
                                            Icons.navigate_next_sharp),
                                        onTap: () {
                                          !isLoggedIn
                                              ? Get.to(SignInScreen())
                                              : showModalBottomSheet(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder: (contex) {
                                                    return Container(
                                                      height: 200,
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 20),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              20),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          ListTile(
                                                            leading: const Icon(
                                                              Iconsax
                                                                  .call_calling,
                                                              size: 25,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            title: const Text(
                                                              'Call Agent',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                launchUrlString(
                                                                    'tel:09072026425'),
                                                          ),
                                                          Divider(),
                                                          ListTile(
                                                            leading: const Icon(
                                                              Iconsax.message,
                                                              size: 25,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            title: const Text(
                                                              'Chat Support',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Map data = user;
                                                              Get.to(ChatScreen(
                                                                user: data,
                                                              ));
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                        },
                                      ),
                                      const Divider(),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          isLoggedIn
                                              ? Iconsax.logout
                                              : Iconsax.login,
                                          color: isLoggedIn
                                              ? mainColor
                                              : Colors.green,
                                        ),
                                        onTap: () {
                                          ref
                                              .read(authtControllerProvider)
                                              .signOut();
                                        },
                                        title: Text(
                                          isLoggedIn ? 'Log out' : 'Log in',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        !isLoggedIn
                            ? const SizedBox(height: 30)
                            : const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
