class Product {
  String title;
  String description;
  int price;
  String imageUrl;
  List<dynamic> favorite;
  String productID;
  int rating;
  String tag;
  bool isFav;
  Product({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.favorite,
    this.productID,
    this.rating,
    this.isFav,
    this.tag,
  });

  Product.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['imageUrl'] ?? '';
    tag = json['tag'];
    isFav = json['isFav'];
    favorite = json['favorite'] == null
        ? []
        : List<dynamic>.from(json['favorite'].map((e) => e));
    productID = json['productID'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['favorite'] == null ? [] : List<dynamic>.from(favorite.map((e) => e));
    data['productID'] = productID;
    data['rating'] = rating;
    data['tag'] = tag;
    data['isFav'] = isFav;
    return data;
  }
}
