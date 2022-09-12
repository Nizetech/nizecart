class OrderModel {
  final String username;
  final String title;
  // final String description;
  final int quantity;
  final String address;
  // final bool paymentMethod;
  final String phoneNumber;
  final int totalAmount;
  OrderModel({
    this.username,
    this.title,
    // this.description,
    this.quantity,
    this.phoneNumber,
    this.totalAmount,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'title': title,
      // 'description': description,
      'quantity': quantity,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      username: map['username'],
      title: map['title'],
      // description: map['description'],
      quantity: map['quantity'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
    );
  }
}
