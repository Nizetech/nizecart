import 'dart:io';

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
      String imageUrl, String title, String description, int price) {
    productRepository.addProduct(
      imageUrl: imageUrl,
      title: title,
      description: description,
      price: price,
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

  // Update Product
  void updateProduct(
    String imageUrl,
    String title,
    String description,
    int price,
  ) {
    productRepository.updateProduct(
      imageUrl: imageUrl,
      title: title,
      description: description,
      price: price,
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
    String title,
    String description,
    int quantity,
    int totalAmount,
    String phoneNumber,
    String address,
  }) {
    return productRepository.orders(
      username: username,
      title: title,
      // description: description,
      quantity: quantity,
      totalAmount: totalAmount,
      phoneNumber: phoneNumber,
      address: address,
    );
  }
}
