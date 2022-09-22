import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String userID;
  final String orderID;
  final DateTime orderDate;
  final String username;
  final String title;
  final int quantity;
  final String address;
  final List productDetails;
  final String phoneNumber;
  final int totalAmount;
  OrderModel({
    this.username,
    this.orderID,
    this.orderDate,
    this.title,
    this.userID,
    this.quantity,
    this.phoneNumber,
    this.totalAmount,
    this.address,
    this.productDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'orderID': orderID,
      'title': title,
      'userID': userID,
      'ordered_date': Timestamp.now(),
      'quantity': quantity,
      'phoneNumber': phoneNumber,
      'address': address,
      'productDetails': productDetails,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      username: map['username'],
      title: map['title'],
      userID: map['userID'],
      orderID: map['orderID'],
      orderDate: map[Timestamp.now()],
      quantity: map['quantity'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      productDetails: map['productDetails'],
    );
  }
}
