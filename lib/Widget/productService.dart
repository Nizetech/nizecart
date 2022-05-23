import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProductService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference products = firestore.collection('products');
}
