import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';

import '../Auth/controller/auth_controller.dart';
import '../Widget/component.dart';

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

  static var box = Hive.box('name');
  final String email = box.get('email');
  final String fName = box.get('displayName');
  String lName = box.get('lname');

  void updateImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    var file = await picker.pickImage(
      source: source,
      imageQuality: 30,
    );

    if (file != null) {
      ref.read(authtControllerProvider).updateProfileImage(
            File(file.path),
          );
      Get.back();
      setState(() {});
      // user.reload();
    }
    return;
  }

  bool isLocked = false;

  @override
  Widget build(BuildContext context) {
    // user.reload();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        // title: const Text(
        //   'Profile',
        //   style: TextStyle(fontSize: 20),
        // ),
        // centerTitle: true,
        // actions: [
        //   IconButton(icon: const Icon(Icons.more_vert_sharp), onPressed: () {}),
        // ],
      ),
      backgroundColor: white,
      body: StreamBuilder(
          // future: ref.read(authtControllerProvider).getUserDetails(),
          stream: ref.read(authtControllerProvider).userDetails(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              print(snapshot.data['photoUrl']);
              String data = snapshot.data['photoUrl'];
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
                              margin: EdgeInsets.only(bottom: 50),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(40),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
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
                                  borderRadius: BorderRadius.vertical(
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
                                          ClipRRect(
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
                                      child: data == null
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
                                              Get.dialog(
                                                Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
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
                                                            style: ButtonStyle(
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
                                                            icon: Icon(
                                                              Iconsax.image,
                                                              size: 15,
                                                            ),
                                                            label: Text(
                                                              'Choose from camera',
                                                            ),
                                                            style: ButtonStyle(
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
                                SizedBox(height: 10),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        '$fName ' + '$lName',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '$email',
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
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
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Iconsax.user,
                                          color: mainColor,
                                        ),
                                        title: Text(
                                          'Account settings',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.navigate_next_sharp),
                                      ),
                                      Divider(),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Iconsax.shopping_bag,
                                          color: mainColor,
                                        ),
                                        title: Text(
                                          'Order',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.navigate_next_sharp),
                                      ),
                                      Divider(),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Iconsax.finger_cricle,
                                          color: mainColor,
                                        ),
                                        title: const Text(
                                          'Biomertrics',
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
                                            )
                                                .then((val) {
                                              if (val) {
                                                print(val);
                                                setState(() {
                                                  isLocked = val;
                                                  // isLocked = !isLocked;
                                                  val = !isLocked;
                                                });
                                                Hive.box('name')
                                                    .put('isLocked', isLocked);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      Divider(),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Iconsax.info_circle,
                                          color: mainColor,
                                        ),
                                        title: Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.navigate_next_sharp),
                                      ),
                                      Divider(),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Iconsax.message_question,
                                          color: mainColor,
                                        ),
                                        title: Text(
                                          'Help',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing:
                                            Icon(Icons.navigate_next_sharp),
                                      ),
                                      Divider(),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Iconsax.logout,
                                          color: mainColor,
                                        ),
                                        onTap: () {
                                          ref
                                              .read(authtControllerProvider)
                                              .signOut();
                                        },
                                        title: Text(
                                          'Log out',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
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
