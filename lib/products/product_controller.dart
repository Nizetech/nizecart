import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';
import 'package:nizecart/products/product_repository.dart';

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
    ref.read(productRepositoryProvider).addProduct(
          imageUrl: imageUrl,
          title: title,
          description: description,
          price: price,
        );
  }

  // Delete Product
  void deleteProduct(String productID) {
    ref.read(productControllerProvider).deleteProduct(productID);
  }

  // Get product
  Future<List> getProduct() {
    return ref.read(productControllerProvider).getProduct();
  }

  // Update Product
  void updateProduct(
    String imageUrl,
    String title,
    String description,
    String price,
  ) {
    ref.read(productRepositoryProvider).updateProduct(
          imageUrl: imageUrl,
          title: title,
          description: description,
          price: price,
        );
  }

  // Add Favorite
  void addFavorite(Map product) {
    ref.read(productRepositoryProvider).addFavorite(product);
  }

  // Remove from favorite
 void removeFavorite(Map product) {
     ref.read(productRepositoryProvider).removeFavorite(product);
  }

  // get favProduct
  Future<List> getFavProduct() {
    return ref.read(productRepositoryProvider).getFavProduct();
  }
}
