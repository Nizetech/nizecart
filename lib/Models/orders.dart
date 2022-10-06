import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String userID;
  final String orderID;
  final DateTime orderDate;
  final String username;
  final String title;
  final int quantity;
  final String address;
  final String country;
  final String city;
  final String email;
  final String postCode;
  final String status;
  final String trackNumber;
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
    this.productDetails,
    this.totalAmount,
    this.address,
    this.status,
    this.city,
    this.country,
    this.trackNumber,
    this.email,
    this.postCode,
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
      'city': city,
      'country': country,
      'email': email,
      'status': status,
      'postCode': postCode,
      'trackNumber': trackNumber,
      'totalAmount': totalAmount,
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
      status: map['status'],
      city: map['city'],
      country: map['country'],
      email: map['email'],
      postCode: map['postCode'],
      totalAmount: map['totalAmount'],
      trackNumber: map['trackNumber'],
      productDetails: map['productDetails'],
    );
  }
}
