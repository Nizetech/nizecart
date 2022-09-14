import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Models/orders.dart';
import 'package:nizecart/Models/product_model.dart';

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
      {String imageUrl, String title, String description, int price}) async {
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
    print(url);
    return url;
  }

  // delete product
  void deleteProduct() async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference products = firestore.collection('Products');
    try {
      Reference storageReference = firebaseStorage.ref('images');
      await products.doc(productID).delete();
      await storageReference.child(productID).delete();
      showToast('Product deleted');
    } catch (e) {
      print(e.toString());
      showErrorToast(e.toString());
    }
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

  Future<List> searchProduct(String query) async {
    CollectionReference products = firestore.collection('Products');
    try {
      // List<Product> items =
      // QuerySnapshot snaps =
      //     await products.where('title', isEqualTo: query).get();
      //     snaps.docs.map((doc) => Product.fromJson(doc.data())).toList();
      //     await products.where('title', isEqualTo: query).get();
      // List<Product> items = [];
      var snaps = await products.where('title', isEqualTo: query).get();
      List<Map> items = [];
      List<QueryDocumentSnapshot> docs = snaps.docs;
      for (var item in snaps.docs) {
        items.add(item.data());
      }
      print(items);
      return items;
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
      );
      await userCredential
          .doc(getUser().uid)
          .collection('order')
          .doc(orderId)
          .set(orderData.toMap());
      showToast('Order placed successfully');
      return true;
    } catch (e) {
      print(e.toString());
      showErrorToast('Something went wrong');
      return false;
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
  void removeFavorite(Map product) async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference userCredential = firestore.collection('Users');
    userCredential
        .doc(getUser().uid)
        .collection('favourite')
        .doc(productID)
        .delete()
        .then((value) => showErrorToast('Product removed from favorites'));
    await userCredential.doc(getUser().uid).update({
      'favorite': false,
    });
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
