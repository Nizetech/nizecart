import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  Future<String> uploadFile(File file, String url) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('images/${(DateTime.now()).millisecondsSinceEpoch}');
    await ref.putFile(file);

    var url = await ref.getDownloadURL();
    // imageUrl = url;
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
}
