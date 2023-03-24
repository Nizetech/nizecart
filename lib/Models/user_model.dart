import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final DateTime dateCreated;
  final String email;
  final String pwd;
  final String firstName;
  final String lastName;
  final String displayName;
  final String phoneNumber;
  final String photoUrl;
  final String country;
  final String city;
  final String address;
  final String postCode;
  final String uid;
  final String token;

  UserModel({
    this.dateCreated,
    this.email,
    this.pwd,
    this.firstName,
    this.lastName,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.address,
    this.country,
    this.city,
    this.postCode,
    this.uid,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'date_created': Timestamp.now(),
      'email': email,
      'firstName': firstName,
      'last_name': lastName,
      'phone': phoneNumber,
      'photoUrl': photoUrl,
      'token': token,
      'address': address,
      'country': country ?? '',
      'city': city ?? '',
      'postCode': postCode ?? '',
      'displayName': displayName ?? '',
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      dateCreated: map['date_created'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['last_name'],
      phoneNumber: map['phone'],
      photoUrl: map['PhotoUrl'] ?? '',
      address: map['address'] ?? '',
      token: map['token'] ?? '',
      postCode: map['postCode'] ?? '',
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      displayName: map['displayName'] ?? '',
      uid: map['uid'],
    );
  }
}
