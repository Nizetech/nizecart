import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nizecart/Widget/component.dart';

class ProductService {
  String downloadUrl;
  FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection('Users');
  CollectionReference products = firestore.collection('products');

  User getUser() => auth.currentUser;

  Future<List> getProducts() async {
    QuerySnapshot snapshot = await products.get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    List<Map> data = [];
    for (var item in docs) {
      data.add(item.data());
    }
    return data;
  }

  // String imageUrl;

  Future<String> uploadFile(
    File file,
  ) async {
    // if (file == null) {
    //   return loader();
    // }
    var ref = FirebaseStorage.instance
        .ref()
        .child('images/${(DateTime.now()).millisecondsSinceEpoch}');
    await ref.putFile(file);

    var url = await ref.getDownloadURL();

    print(url);

    return url;
  }

  Future<String> loadImage() async {
    try {
      await uploadFile;
      return downloadUrl;
    } catch (e) {
      print('error' + e);
      return null;
    }
  }

  Future<bool> signUp({
    String email,
    String pwd,
    String fname,
    String lname,
    String phn,
  }) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      if (user.user != null) {
        await users.doc(user.user.uid).set({
          'name': fname,
          'last_name': lname,
          'phone': phn,
          'email': email,
          'uid': user.user.uid,
        });
        // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();
      }
      return true;
    } catch (e) {
      print(e);
      FirebaseAuthException ext = e;
      showErrorToast(ext.message);
      return false;
    }
  }

  Future<bool> signIn(String email, String pwd) async {
    try {
      UserCredential user =
          await auth.signInWithEmailAndPassword(email: email, password: pwd);
      if (user.user != null) {
        users.doc(user.user.uid).update({
          'date_modifield': Timestamp.now(),
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      FirebaseAuthException ext = e;
      if (e.message ==
          'The account is invalid or the user does not have a password.') {
        showErrorToast('User not found');
        Get.back();
      } else if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        showErrorToast('This email does not exist');
        Get.back();
      } else {
        showErrorToast(ext.message);
        Get.back();
      }

      return false;
    }
  }

  Future<Map> getUserDetails() async {
    DocumentSnapshot shot = await users.doc(getUser().uid).get();
    return shot.data();
  }

//   Future<bool> addProduct({
//     String title,
//     String description,
//     String price,
//     String imageUrl,
//   }) async {
//     if (products != null) {
//       await uploadFile;
//       await users.doc(products.id).set({
//         'title': title,
//         'description': description,
//         'price': price,
//         'imageUrl': imageUrl,
//       });
//       // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();
//     }
//     return true;
//   }
}
