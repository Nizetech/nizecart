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
        isFav: false,
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
      QuerySnapshot snaps = await products
          .where('title'.toLowerCase().contains(query),
              isEqualTo: query.toLowerCase())
          .get();

      return snaps.docs.map((e) => e.data() as Map).toList();
    } catch (e) {
      print(e.toString());
      showErrorToast(e.toString());
      return [];
    }
  }

  // Update profileImage
  Future<String> updateProdImage(File image, String imageUrl) async {
    Reference storageReference = firebaseStorage.ref('images');

    CollectionReference collectionReference = firestore.collection('Products');
    try {
      //Upload image to firebase storage
      UploadTask uploadTask =
          storageReference.child(getUser().uid).putFile((image));
      // Get url of image

      uploadTask.then((value) {
        value.ref.getDownloadURL().then((url) {
          imageUrl = url;
          collectionReference.doc(getUser().uid).update({
            'imageUrl': imageUrl,
            // 'imageUploaded': true,
          });
        });
      });
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  //Update product
  Future<void> updateProduct({
    // String imageUrl,
    String title,
    String description,
    int price,
    File image,
  }) async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference products = firestore.collection('Products');
    try {
      await updateProdImage(image, imageUrl);
      await products.doc(productID).update({
        'title': title, // Apple
        'description': description, // A fruit
        'price': price, // 1.99
      });
      showToast('Product updated successfully');
    } catch (e) {
      print(e.toString());
      showErrorToast('Could not update product');
    }
  }

  // add favproduct
  void addFavorite(Map<String, dynamic> product) async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference userCredential = firestore.collection('Users');
    try {
      product.addAll({
        'favId': productID,
      });
      await userCredential
          .doc(getUser().uid)
          .collection('favorite')
          .doc(productID)
          .set(product)
          .then((value) {
        showToast('Product added to favorites');
      });
      await userCredential.doc(getUser().uid).update({
        'isFav': true,
      });
    } catch (e) {
      print(e.toString());
    }
  }

// Make order
  Future<bool> orders({
    String username,
    int quantity,
    int totalAmount,
    String phoneNumber,
    String address,
    String city,
    String email,
    String postCode,
    String country,
    List productDetails,
  }) async {
    final orderId = '${DateTime.now().microsecondsSinceEpoch}';
    CollectionReference orderCredential = firestore.collection('Orders');
    String track = getRandomString(4);
    try {
      var orderData = OrderModel(
        username: username,
        orderID: orderId,
        orderDate: DateTime.now(),
        userID: auth.currentUser.uid,
        quantity: quantity,
        status: 'Pending',
        phoneNumber: phoneNumber,
        totalAmount: totalAmount,
        address: address,
        postCode: postCode,
        trackNumber: track,
        city: city,
        email: email,
        country: country,
        productDetails: productDetails,
      );
      await orderCredential.doc(orderId).set(orderData.toMap());
      // showToast('Order placed successfully');
      Get.to(SuccessPage());
      return true;
    } catch (e) {
      print(e.toString());
      showErrorToast('Something went wrong');
      return false;
    }
  }

  // Get Order
  Future<List> getOrder() async {
    CollectionReference order = firestore.collection('Order');
    try {
      QuerySnapshot snapshot =
          await order.where('userID', isEqualTo: auth.currentUser.uid).get();
      // Map data = snapshot.data();
      // snaps.docs.map((e) => e.data() as Map).toList()
      return snapshot.docs;
    } catch (e) {
      print(e.toString());
    }
  }

  //Make Payment with FLutterwave
  Future<Map<String, dynamic>> payWithFlutterWave({
    String amount,
    String username,
    int quantity,
    int totalAmount,
    String phoneNumber,
    String address,
    String city,
    String email,
    String postCode,
    String country,
    List productDetails,
    BuildContext context,
  }) async {
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
        await orders(
          username: username,
          quantity: quantity,
          totalAmount: totalAmount,
          phoneNumber: phoneNumber,
          address: address,
          city: city,
          email: email,
          postCode: postCode,
          country: country,
          productDetails: productDetails,
        );
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

// Get product
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
    try {
      await userCredential
          .doc(getUser().uid)
          .collection('favorite')
          .doc(productID)
          .delete();
      await userCredential.doc(getUser().uid).update({
        'isFav': true,
      });
      print('product credential: $userCredential');
      print('user id: ${getUser().uid}');
      showErrorToast('Product removed from favorites');
    } catch (e) {
      showErrorToast(e.toString());

      print(e.toString());
    }
  }

  // delete product
  void deleteProduct(String productID) async {
    // final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference products = firestore.collection('Products');
    try {
      Reference storageReference = firebaseStorage.ref('images');
      await products.doc(productID).delete();
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
        await userCredential.doc(getUser().uid).collection('favorite').get();
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
