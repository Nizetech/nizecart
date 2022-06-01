import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/product_screen.dart';
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

  Future<bool> signInWithGoogle() async {
    try {
      //Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      final UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (user.user != null) {
        List search = user.user.displayName.split(' ');
        search.addAll(user.user.email.split('@'));
        search.add(user.user.uid);
        search.add(user.user.phoneNumber);
        await users.doc(user.user.uid).set({
          'name': user.user.displayName,
          'last_name': user.user.displayName,
          'phone': user.user.phoneNumber,
          'email': user.user.email,
          'uid': user.user.uid,
          'date_created': Timestamp.now(),
          'date_updated': Timestamp.now(),
        });
        // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();
        Hive.box('name').put('phone', user.user.phoneNumber);
        return true;
      } else {
        showErrorToast('Google sign in failed');
        return false;
      }
    } catch (e) {
      print(e);
      showErrorToast('Google sign in failed');
      return false;
    }
  }

  Future<bool> signUp({
    String email,
    String pwd,
    String displayName,
    String lname,
    String phone,
  }) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      if (user.user != null) {
        user.user.updateDisplayName(displayName);
        user.user.sendEmailVerification();
        List search = displayName.split(' ');
        search.addAll(email.split('@'));
        search.add(user.user.uid);
        search.add(phone);
        await users.doc(user.user.uid).set({
          'name': displayName,
          'last_name': lname,
          'phone': phone,
          'email': email,
          'uid': user.user.uid,
          'date_created': Timestamp.now(),
          'date_updated': Timestamp.now(),
        });
        // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();
        Hive.box('name').put('phone', user.user.phoneNumber);
        return true;
      }
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
