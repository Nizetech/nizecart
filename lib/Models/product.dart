class Product {
  final String id;
  final String title;
  final String image;
  final double price;
  final int quantity;
  bool isFav;

  Product(
      {this.id,
      this.image,
      this.title,
      this.price,
      this.isFav = false,
      this.quantity});
}
