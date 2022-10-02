import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:nizecart/Models/orders.dart';
import 'package:nizecart/Models/product_model.dart';
import 'package:nizecart/Screens/image_input.dart';
import 'package:nizecart/Screens/success_screen.dart';
import 'package:nizecart/botton_nav.dart';
import 'package:nizecart/keys/keys.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import '../Widget/component.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository(
    auth: FirebaseAuth.instance,
    firebaseStorage: FirebaseStorage.instance,
    firestore: FirebaseFirestore.instance));

class ProductRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  ProductRepository({this.auth, this.firebaseStorage, this.firestore});

  User getUser() => auth.currentUser;

  //Add product
  void addProduct(
      {String imageUrl,
      String title,
      String description,
      int price,
      String tag}) async {
    //set document id
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference products = firestore.collection('Products');

    /// get user id
    try {
      var productData = Product(
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        favorite: [],
        productID: productID,
        rating: 0,
        tag: tag,
      );
      await products.doc(productID).set(productData.toJson());

      print(productData);
    } catch (e) {
      print(e.toString());
      // FirebaseException ext = e;
      showErrorToast(e.toString());
    }
  }

  // upload product image
  Future<String> uploadFile(
    File file,
  ) async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';

    var ref = FirebaseStorage.instance.ref().child('images').child(productID);
    await ref.putFile(file);
    var url = await ref.getDownloadURL();
    // print(url);
    return url;
  }

  // Get products
  Future<List> getProducts() async {
    CollectionReference products = firestore.collection('Products');
    try {
      var snapshot = await products.get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      List<Map> data = [];
      for (var item in docs) {
        data.add(item.data());
      }
      // print(data);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get productCategory
  Future<List> productCategory(String tag) async {
    CollectionReference products = firestore.collection('Products');
    try {
      QuerySnapshot snapshot =
          await products.where('tag', isEqualTo: tag).get();
      // List<QueryDocumentSnapshot> docs = snapshot.docs;
      // List<Map> data = [];
      // for (var item in docs) {
      //   data.add(item.data());
      // }
      // print('Service product: $data');
      // return data;
      return snapshot.docs.map((e) => e.data() as Map).toList();
    } catch (e) {
      print(e.toString());
      showErrorToast(e.toString());
      return [];
    }
  }

  Future<List> searchProduct(String query) async {
    CollectionReference products = firestore.collection('Products');
    try {
      QuerySnapshot snaps =
          await products.where('title'.toLowerCase(), isEqualTo: query).get();

      return snaps.docs.map((e) => e.data() as Map).toList();
    } catch (e) {
      print(e.toString());
      showErrorToast(e.toString());
      return [];
    }
  }

  //Update product
  Future<void> updateProduct({
    String imageUrl,
    String title,
    String description,
    int price,
  }) async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference products = firestore.collection('Products');
    try {
      await products.doc(productID).update({
        'title': title, // Apple
        'description': description, // A fruit
        'price': price, // 1.99
        'image': imageUrl,
      });
      showToast('Product updated successfully');
    } catch (e) {
      print(e.toString());
      showErrorToast('Could not update product');
    }
  }

  // add favproduct
  void addFavorite(Map product) async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference userCredential = firestore.collection('Users');
    userCredential
        .doc(getUser().uid)
        .collection('favourite')
        .doc(productID)
        .set(product)
        .then((value) {
      showToast('Product added to favourites');
    });
    await userCredential.doc(getUser().uid).update({
      'favorite': true,
    });
  }

// Make order
  Future<bool> orders({
    String username,
    String title,
    // String description,
    int quantity,
    int totalAmount,
    String phoneNumber,
    String address,
    List productDetails,
  }) async {
    final orderId = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference userCredential = firestore.collection('Users');

    try {
      var orderData = OrderModel(
        username: username,
        orderID: orderId,
        orderDate: DateTime.now(),
        userID: auth.currentUser.uid,
        title: title,
        quantity: quantity,
        phoneNumber: phoneNumber,
        totalAmount: totalAmount,
        address: address,
        productDetails: productDetails,
      );
      await userCredential
          .doc(getUser().uid)
          .collection('order')
          .doc(orderId)
          .set(orderData.toMap());
      // showToast('Order placed successfully');
      Get.to(SuccessPage());
      return true;
    } catch (e) {
      print(e.toString());
      showErrorToast('Something went wrong');
      return false;
    }
  }

  //Make Payment with FLutterwave
  Future<Map<String, dynamic>> payWithFlutterWave(
      String amount, BuildContext context) async {
    try {
      String trxId = DateTime.now().millisecondsSinceEpoch.toString();
      User user = FirebaseAuth.instance.currentUser;
      final Customer customer = Customer(
        name: user.displayName,
        phoneNumber: user.phoneNumber,
        email: user.email,
      );

      final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: FLWPUBKEY,
        currency: "NGN",
        redirectUrl: "my_redirect_url",
        txRef: trxId,
        amount: amount,
        customer: customer,
        paymentOptions: "ussd, card, barter",
        customization: Customization(title: "Add Money"),
        isTestMode: true,
      );

      ChargeResponse response = await flutterwave.charge();
      if (response.success) {
        showToast('Successful');
        // Verify transaction
        var responseData = response.toJson();

        responseData['date'] = FieldValue.serverTimestamp();

        return responseData;
      } else {
        showErrorToast('Failed');
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> getProduct() async {
    CollectionReference products = firestore.collection('Products');
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    DocumentSnapshot snapshot = await products.doc(productID).get();
    // Map data = snapshot.data();
    return snapshot.data();
  }

  // remove favProduct
  void removeFavorite(String productID) async {
    CollectionReference userCredential = firestore.collection('Users');
    userCredential
        .doc(getUser().uid)
        .collection('favourite')
        .doc(productID)
        .delete();

    showErrorToast('Product removed from favorites');
    await userCredential.doc(getUser().uid).update({
      'favorite': false,
    });
  }

  // delete product
  void deleteProduct(String productID) async {
    // final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference products = firestore.collection('Products');
    try {
      Reference storageReference = firebaseStorage.ref('images');
      await products.doc(productID).delete();
      // await storageReference.child(productID).delete();
      showToast('Product deleted');
    } catch (e) {
      print(e.toString());
      showErrorToast(e.toString());
    }
  }

  //get favProduct
  Future<List> getFavProduct() async {
    CollectionReference userCredential = firestore.collection('Users');
    QuerySnapshot snapshot =
        await userCredential.doc(getUser().uid).collection('favourite').get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    List<Map> data = [];
    for (var item in docs) {
      data.add(item.data());
    }
    // print(data);
    return data;
  }
}

//   //Get product by title
//   Future<Map> getProductByTitle(String title) async {
//     QuerySnapshot snapshot = await products.where('title', isEqualTo: title).get();
//     List<QueryDocumentSnapshot> docs = snapshot.docs;
//     Map data = docs[0].data();
//     return data;
//   }
