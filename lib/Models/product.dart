import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String userId;
  final String userEmail;
  final String userName;
  final String userPhone;
  final String userAddress;
  bool isFavorite;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.userId,
    this.userEmail,
    this.userName,
    this.userPhone,
    this.userAddress,
    this.isFavorite = false,
  });

  Future<void> addProduct(Product product) async {
    final url =
        'https://nizecart-6e6dd-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          // 'imageUrl': product.imageUrl,
        }),
      );
      final responseData = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      await Hive.box('products').add(responseData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  int get itemsCount {
    var box = Hive.box('name');
    List selectedItems = box.get('cart');
    return selectedItems == null ? 0 : selectedItems.length;
  }

  double get totalAmount {
    var totalAmount = 0.0;
    var box = Hive.box('name');
    List selectedItems = box.get('cart');
    if (selectedItems != null) {
      for (var i = 0; i < selectedItems.length; i++) {
        totalAmount += selectedItems[i]['price'] * selectedItems[i]['quantity'];
      }
    }
    return totalAmount.roundToDouble();
  }

// void removeItem(int index) {
//   var box = Hive.box('name');
//   List selectedItems = box.get('cart');
//   selectedItems.removeAt(index);
//   box.put('cart', selectedItems);
//   Fluttertoast.showToast(
//     msg: 'Item removed from cart',
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.red,
//     textColor: Colors.white,
//     fontSize: 16.0,
//   );
// }

  int get totalQuantity {
    var totalQuantity = 0;
    var box = Hive.box('name');
    List selectedItems = box.get('cart');
    if (selectedItems != null && selectedItems.length > 0) {
      for (var i = 0; i < selectedItems.length; i++) {
        totalQuantity += selectedItems[i]['quantity'];
      }
    }
    return totalQuantity;
  }

// const url =
//     'https://nizecart-default-rtdb.firebaseio.com/'; // add .json at the end of url to get json response from firebase database (not needed for hive)

//   var box = Hive.box('name');
//   List selectedItems = box.get('cart');

//   http.post(url, body: json.encode(selectedItems)).then((response) {
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   });
}
