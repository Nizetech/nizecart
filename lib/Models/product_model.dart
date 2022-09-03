// 'title': title,
//     'description': description,
//     'price': price,
//     'imageUrl': imageUrl,
//     'favorite': false,
//     'productID': productID,
//     'rating': 0,

class Product {
  String title;
  String description;
  int price;
  String imageUrl;
  bool favorite;
  String productID;
  int rating;
  Product({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.favorite,
    this.productID,
    this.rating,
  });

  Product.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['imageUrl'] ?? '';
    favorite = json['favorite'];
    productID = json['productID'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['favorite'] = favorite;
    data['productID'] = productID;
    data['rating'] = rating;
    return data;
  }
}
