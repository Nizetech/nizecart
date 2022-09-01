// 'title': title,
//     'description': description,
//     'price': price,
//     'imageUrl': imageUrl,
//     'favorite': false,
//     'productID': productID,
//     'rating': 0,

class Product {
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  final bool favorite;
  final String productID;
  final int rating;
  Product({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.favorite,
    this.productID,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'favorite': favorite,
      'productID': productID,
      'rating': rating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'] ?? '',
      favorite: map['favorite'],
      productID: map['productID'],
      rating: map['rating'],
    );
  }
}
