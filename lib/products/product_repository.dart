import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    var productData = Product(
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      favorite: false,
      productID: productID,
      rating: 0,
    );
    await products.doc(productID).set({
      productData.toMap(),
    });
  }

  // delete product
  void deleteProduct(String productID) async {
    CollectionReference products = firestore.collection('Products');
    Reference storageReference = firebaseStorage.ref('profilePicture');
    await products.doc(productID).delete();
    await storageReference.child(productID).delete();
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

  //Update product
  void updateProduct({
    String imageUrl,
    String title,
    String description,
    String price,
  }) async {
    final productID = '${DateTime.now().millisecondsSinceEpoch}';
    CollectionReference products = firestore.collection('Products');
    await products.doc(productID).update({
      'title': title, // Apple
      'description': description, // A fruit
      'price': price, // 1.99
      'image': imageUrl,
    });
  }

  // add favproduct
  void addFavorite(Map product) async {
    CollectionReference userCredential = firestore.collection('Users');
    userCredential
        .doc(getUser().uid)
        .collection('favourite')
        .doc(product['productID'])
        .set(product)
        .then((value) => showToast('Product added to favourites'));
    await userCredential.doc(getUser().uid).update({
      'favorite': true,
    });
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
    CollectionReference userCredential = firestore.collection('Users');
    userCredential
        .doc(getUser().uid)
        .collection('favourite')
        .doc(product['productID'])
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
        await userCredential.doc(getUser().uid).collection('favorite').get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    List<Map> data = [];
    for (var item in docs) {
      data.add(item.data());
    }
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