import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  String downloadUrl;
  CollectionReference products = firestore.collection('products');

  Future<List> getProducts() async {
    QuerySnapshot snapshot = await products.get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    List<Map> data = [];
    for (var item in docs) {
      data.add(item.data());
    }
    return data;
  }

  Future<String> loadImage() async {
    try {
      await getImage();
      return downloadUrl;
    } catch (e) {
      print('error' + e);
      return null;
    }
  }

  Future<void> getImage() async {
    downloadUrl = await FirebaseStorage.instance
        .ref()
        .child('images/image.jpg')
        .getDownloadURL();
  }
}
