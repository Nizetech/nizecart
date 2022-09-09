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
  final String displayName = box.get('displayName');

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

  @override
  Widget build(BuildContext context) {
    user.reload();
    return Scaffold(
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
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert_sharp), onPressed: () {}),
        ],
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: ref.read(authtControllerProvider).getUserDetails(),
            builder: (context, snapshot) {
              // print(snapshot.data['photoUrl']);
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
              String data = snapshot.data['photoUrl'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () => Get.dialog(Dialog(
                                  backgroundColor: secColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
                                child: Container(
                                    height: 140,
                                    width: 140,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 3,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(75),
                                        color: white),
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
                                          )),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.dialog(Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Change Profile Picture',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              TextButton.icon(
                                                onPressed: () {
                                                  updateImage(
                                                      ImageSource.gallery);
                                                },
                                                icon:
                                                    const Icon(Iconsax.gallery),
                                                label: const Text(
                                                    'Choose from Gallery'),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    secColor,
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              TextButton.icon(
                                                onPressed: () async {
                                                  updateImage(
                                                      ImageSource.camera);
                                                },
                                                icon: Icon(Iconsax.image),
                                                label:
                                                    Text('Choose from camera'),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    secColor,
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ));
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
                                        borderRadius: BorderRadius.circular(75),
                                        color: white),
                                    child: const Icon(
                                      Iconsax.camera,
                                      size: 30,
                                      color: secColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text('$email'),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Account Name: $displayName',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
