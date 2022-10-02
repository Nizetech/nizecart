class UserModel {
  final String email;
  final String pwd;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String photoUrl;
  final String address;
  final String uid;
  UserModel(
      {this.email,
      this.pwd,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.photoUrl,
      this.address,
      this.uid});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'last_name': lastName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'address': address,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['last_name'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['PhotoUrl'] ?? '',
      address: map['address'] ?? '',
      uid: map['uid'],
    );
  }
}
