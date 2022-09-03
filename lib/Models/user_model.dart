class UserModel {
  final String email;
  final String pwd;
  final String fname;
  final String lname;
  final String phone;
  final String photoUrl;
  final String address;
  final String uid;
  UserModel(
      {this.email,
      this.pwd,
      this.fname,
      this.lname,
      this.phone,
      this.photoUrl,
      this.address,
      this.uid});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fname': fname,
      'last_name': lname,
      'phone': phone,
      'photoUrl': photoUrl,
      'address': address,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      fname: map['fname'],
      lname: map['last_name'],
      phone: map['phone'],
      photoUrl: map['PhotoUrl'] ?? '',
      address: map['address'] ?? '',
      uid: map['uid'],
    );
  }
}
