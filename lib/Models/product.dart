class Product {
  final String id;
  final String title;
  final String image;
  final double price;
  int quantity;
  final String description;
  bool isFav;

  Product(
      {this.id,
      this.image,
      this.title,
      this.price,
      this.description,
      this.isFav = false,
      this.quantity});
}
