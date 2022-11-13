import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';
import 'package:nizecart/products/product_repository.dart';

import '../Models/product_model.dart';

final productControllerProvider = Provider((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return ProductController(ref: ref, productRepository: productRepository);
});

class ProductController {
  final ProductRepository productRepository;
  final ProviderRef ref;
  ProductController({this.productRepository, this.ref});

// Add product
  void addProduct(
      {String imageUrl,
      String title,
      String description,
      int price,
      String tag}) {
    productRepository.addProduct(
      imageUrl: imageUrl,
      title: title,
      description: description,
      price: price,
      tag: tag,
    );
  }

  // Delete Product
  void deleteProduct(String productID) {
    productRepository.deleteProduct(productID);
  }

  // Get product
  Future<List> getProduct() {
    return productRepository.getProducts();
  }

  // Get productCategory
  Future<List> productCategory(String tag) {
    return productRepository.productCategory(tag);
  }

  // Update Product
  void updateProduct({
    // String imageUrl,
    String title,
    String description,
    int price,
    File image,
  }) {
    productRepository.updateProduct(
      // imageUrl: imageUrl,
      title: title,
      description: description,
      price: price,
      image: image,
    );
  }

  // Add Favorite
  void addFavorite(Map product) {
    productRepository.addFavorite(product);
  }

  // Remove from favorite
  void removeFavorite(String productID) {
    productRepository.removeFavorite(productID);
  }

  // get favProduct
  Future<List> getFavProduct() {
    return productRepository.getFavProduct();
  }

  // search items
  Future<List> searchProduct(String query) {
    return productRepository.searchProduct(query);
  }

  // Upload File
  Future<String> uploadFile(File file) {
    return productRepository.uploadFile(file);
  }

  // Create Order
  Future<bool> orders({
    String username,
    int quantity,
    int totalAmount,
    String phoneNumber,
    String address,
    String lga,
    String email,
    String postCode,
    String state,
    List productDetails,
  }) {
    return productRepository.orders(
      username: username,
      lga: lga,
      quantity: quantity,
      totalAmount: totalAmount,
      phoneNumber: phoneNumber,
      address: address,
      postCode: postCode,
      state: state,
      productDetails: productDetails,
    );
  }

// Get Order
  // Stream<QuerySnapshot<Object>> streamOrder() {
  //   return productRepository.streamOrder();
  // }

//Get Order
  Future<List> getOrder() {
    return productRepository.getOrder();
  }

  // PayWithPaystack
  // void payStackPay(
  //     {BuildContext context, String email, String name, String amount}) {
  //   return productRepository.payStackPay(
  //       context: context, email: email, name: name, amount: amount);
  // }

  // Pay with flutterwave
  Future<Map<String, dynamic>> payWithFlutterWave({
    String amount,
    String username,
    int quantity,
    int totalAmount,
    String phoneNumber,
    String address,
    String lga,
    String email,
    String postCode,
    String state,
    List productDetails,
    BuildContext context,
  }) {
    return productRepository.payWithFlutterWave(
      amount: amount,
      context: context,
      quantity: quantity,
      totalAmount: totalAmount,
      phoneNumber: phoneNumber,
      address: address,
      lga: lga,
      email: email,
      postCode: postCode,
      state: state,
      productDetails: productDetails,
    );
  }
}
