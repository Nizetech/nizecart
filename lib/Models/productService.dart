import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
import 'package:nizecart/Auth/signInScreen.dart';
import 'package:nizecart/Widget/component.dart';

class ProductService {
  String downloadUrl;
  FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference userCredential = firestore.collection('Users');
  CollectionReference products = firestore.collection('products');
  CollectionReference favourite = firestore.collection('favourite');

  Reference storageReference = FirebaseStorage.instance.ref('profilePicture');

  User getUser() => auth.currentUser;
  final productID = '${DateTime.now().millisecondsSinceEpoch}';

// String id= await products.doc().docID().toString;
//  String id= await products.doc().id.toString();

  // Future<void> signOut() async {
  //   await auth.signOut();
  //   Get.offAllNamed('/signIn');
  // }

//   products.setData({
//   documentID:  ,
//   /* ... */
// });
  // final productID = '${DateTime.now().millisecondsSinceEpoch}';
// set doument id
  // Future<String> setDocumentID(String documentID) async {
  //   await products.doc(documentID).set({
  //     'documentID': documentID,
  //   });
  // }

  static Box box = Hive.box('name');
  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  bool get currentUser {
    return box.get('isLoggedIn', defaultValue: false);
  }

  //Sign out
  Future<void> signOut() async {
    await auth.signOut();
    isLoggedIn = false;
    box.put('isLoggedIn', isLoggedIn);
    await Hive.box('name').delete('fname');
    loader();
    return Get.to(SignInSCreen());
  }

  // delete product

  Future<void> deleteProduct(String productID) async {
    await products.doc(productID).delete();
  }

  Future<List> getProducts() async {
    try {
      var snapshot = await products.get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      List<Map> data = [];
      for (var item in docs) {
        data.add(item.data());
      }
      print(data);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
    // for (var doc in snapshot.docs) {
    //   Map<String, dynamic> data = doc.data();
    // }
  }

// get a particular
  // Future<Map> getProduct(String title) async {
  //   QuerySnapshot snapshot = await products.doc(title).get();
  //   return snapshot.data();
  // }
// add favproduct
  void addFavourite(Map product) {
    userCredential
        .doc(getUser().uid)
        .collection('favourite')
        .doc(product['productID'])
        .set(product)
        .then((value) => showToast('Product added to favourites'));
  }

// remove favProduct
  void removeFavourite(Map product) {
    userCredential
        .doc(getUser().uid)
        .collection('favourite')
        .doc(product['productID'])
        .delete()
        .then((value) => showErrorToast('Product reomved from favourites'));
  }

//get favProduct

  Future<List> getFavProduct() async {
    QuerySnapshot snapshot =
        await userCredential.doc(getUser().uid).collection('favourite').get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    List<Map> data = [];
    for (var item in docs) {
      data.add(item.data());
    }
    return data;
  }

  Future<Map> getProduct(String productID) async {
    // final productID = '${DateTime.now().millisecondsSinceEpoch}';
    try {
      DocumentSnapshot snapshot = await products.doc(productID).get();
      // Map data = snapshot.data();
      return snapshot.data();
    } catch (e) {
      print(e);
      return null;
    }
  }
  // String id;

  //Add product
  Future<void> addProduct(
      String imageUrl, String title, String description, String price) async {
    //set document id

    /// get user id
    await products.doc(productID).set({
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'favorite': false,
      'productID': productID,
      'rating': 0,
    });
    // String id = products.doc().id.toString();
    // await products.add({
    //   'title': title, // Apple
    //   'description': description, // A fruit
    //   'price': price, // 1.99
    //   'image': imageUrl,
    //   // 'userId': auth.currentUser.uid,
    //   'prodId': id,
    // });
  }

  //Update product
  Future<void> updateProduct(
    String imageUrl,
    String title,
    String description,
    String price,
  ) async {
    // String prodId = getUser().uid;
    await products.doc(productID).update({
      'title': title, // Apple
      'description': description, // A fruit
      'price': price, // 1.99
      'image': imageUrl,
    });
  }

  // //Delete product
  // Future<void> deleteProduct(String title) async {
  //   await products.doc(title).delete();
  // }
  // String imageUrl;

//   //Get product by title
//   Future<Map> getProductByTitle(String title) async {
//     QuerySnapshot snapshot = await products.where('title', isEqualTo: title).get();
//     List<QueryDocumentSnapshot> docs = snapshot.docs;
//     Map data = docs[0].data();
//     return data;
//   }

// Update profileImage
  Future<void> updateProfileImage(File image) async {
    try {
      //Upload image to firebase storage
      UploadTask uploadTask =
          storageReference.child(getUser().uid).putFile((image));
      // Get url of image
      String photoUrl;
      uploadTask.then((value) {
        value.ref.getDownloadURL().then((url) {
          photoUrl = url;
          userCredential.doc(getUser().uid).update({
            'profileImage': photoUrl,
            'imageUploaded': true,
          });
          getUser().updatePhotoURL(
            photoUrl,
          );
        });
      });
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  // //Get profileImage
  // Future<String> getProfileImage() async {
  //   QuerySnapshot snapshot =
  //       await userCredential.where('uid', isEqualTo: getUser().uid).get();
  //   List<QueryDocumentSnapshot> docs = snapshot.docs;
  //   // String data = docs[0].data()['profileImage'];
  //   // return data;
  // }

//   //Get displayName
//   Future<String> getDisplayName() async {
//     QuerySnapshot snapshot = await userCredential.where('uid', isEqualTo: getUser().uid).get();
//     List<QueryDocumentSnapshot> docs = snapshot.docs;
//     String data = docs[0].data()['displayName'];
//     return data;
//   }

//   //Update displayName
//   Future<void> updateDisplayName(String displayName) async {
//     await userCredential.doc(getUser().uid).update({
//       'displayName': displayName,
//     });
//   }

//   //Get email
//   Future<String> getEmail() async {
//     QuerySnapshot snapshot = await userCredential.where('uid', isEqualTo: getUser().uid).get();
//     List<QueryDocumentSnapshot> docs = snapshot.docs;
//     String data = docs[0].data()['email'];
//     return data;
//   }

//   //Update email
//   Future<void> updateEmail(String email) async {
//     await userCredential.doc(getUser().uid).update({
//       'email': email,
//     });
//   }

//   //Get phoneNumber
//   Future<String> getPhoneNumber() async {
//     QuerySnapshot snapshot = await userCredential.where('uid', isEqualTo: getUser().uid).get();
//     List<QueryDocumentSnapshot> docs = snapshot.docs;
//     String data = docs[0].data()['phoneNumber'];
//     return data;
//   }

//   //Update phoneNumber
//   Future<void> updatePhoneNumber(String phoneNumber) async {
//     await userCredential.doc(getUser().uid).update({
//       'phoneNumber': phoneNumber,
//     });
//   }

//   //Get address
//   Future<String> getAddress() async {
//     QuerySnapshot snapshot = await userCredential.where('uid', isEqualTo: getUser().uid).get();
//     List<QueryDocumentSnapshot> docs = snapshot.docs;
//     String data = docs[0].data()['address'];
//     return data;
//   }

  // upload product image

  Future<String> uploadFile(
    File file,
  ) async {
    // if (file == null) {
    //   return loader();
    // }
    var ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(getUser().uid + '.jpg');
    await ref.putFile(file);
    var url = await ref.getDownloadURL();
    print(url);
    return url;
  }

  Future<bool> signInWithGoogle() async {
    try {
      //Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      final UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (user.user != null) {
        List search = user.user.displayName.split(' ');
        search.addAll(user.user.email.split('@'));
        search.add(user.user.uid);
        search.add(user.user.phoneNumber);
        await userCredential.doc(user.user.uid).set({
          'fname': user.user.displayName,
          'last_name': user.user.displayName,
          'phone': user.user.phoneNumber,
          'email': user.user.email,
          // 'profileImage': user.user.photoUrl,
          'uid': user.user.uid,
          'date_created': Timestamp.now(),
          'date_updated': Timestamp.now(),
        });
        // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();
        Hive.box('name').put('displayName', user.user.displayName);
        Hive.box('name').put('email', user.user.email);
        return true;
      } else {
        showErrorToast('Google sign in failed');
        return false;
      }
    } catch (e) {
      print(e);
      showErrorToast('Google sign in failed');
      return false;
    }
  }

  Future<bool> signUp({
    String email,
    String pwd,
    String displayName,
    String lname,
    String phone,
    String photoUrl,
    String address,
  }) async {
    try {
      //create user on firebase auth
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      if (user.user != null) {
        // user.user.updateDisplayName(fname);

        // user.user.sendEmailVerification();
        List search = displayName.split(' ');
        search.addAll(email.split('@'));
        search.add(user.user.uid);
        search.add(phone);
        await userCredential.doc(user.user.uid).set(
          {
            'fname': displayName,
            'last_name': lname,
            'phone': phone,
            'email': email,
            'uid': user.user.uid,
            'date_created': Timestamp.now(),
            'date_updated': Timestamp.now(),
          },
        );
        // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();
        Hive.box('name').put('displayName', displayName);
        Hive.box('name').put('lname', lname);
        Hive.box('name').put('email', user.user.email);
        return true;
      }
    } catch (e) {
      print(e);
      FirebaseException ext = e;
      showErrorToast(ext.message);
      return false;
    }
  }

  Future<bool> signIn(String email, String pwd) async {
    try {
      UserCredential user =
          await auth.signInWithEmailAndPassword(email: email, password: pwd
              // email: user['email'], password: user['pwd'],
              );
      // if (user.user != null) {
      // users.doc(user.user.uid).update({
      //   'date_modifield': Timestamp.now(),
      // });

      Hive.box('name').put('email', user.user.email);
      return true;
      // } else {
      //   return false;
      // }
    } catch (e) {
      FirebaseAuthException ext = e;
      if (e.message ==
          'The account is invalid or the user does not have a password.') {
        showErrorToast('User not found');
        Get.back();
      } else if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        showErrorToast('This email does not exist');
        Get.back();
      } else {
        showErrorToast(ext.message);
        Get.back();
        Get.back();
      }
      return false;
    }
  }

  Future<Map> getUserDetails() async {
    DocumentSnapshot shot = await userCredential.doc(getUser().uid).get();
    return shot.data();
  }

  Future<void> sendVerificationEmail() async {
    await auth.currentUser.sendEmailVerification();
    showToast("Verification email sent");
  }

  void resetPwd(String email) {
    auth
        .sendPasswordResetEmail(email: email)
        .then((value) => showToast("Sent Successfully - Check your Mail"));
  }

  // Future<void> showDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime.now(),
  //       lastDate: DateTime(2101));
  //   if (picked != null) {
  //     final TimeOfDay time = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //     );
  //     if (time != null) {
  //       date = TextEditingController(
  //         text: DateFormat('dd-MM-yyyy').format(picked) +
  //             " " +
  //             time.format(context),
  //       );
  //     }
  //   }
  // }

}
