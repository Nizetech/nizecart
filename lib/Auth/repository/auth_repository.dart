import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/image_input.dart';
import 'package:nizecart/botton_nav.dart';

import '../../Models/user_model.dart';
import '../../Widget/component.dart';
import '../screens/signInScreen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firebaseStorage: FirebaseStorage.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  AuthRepository({
    this.auth,
    this.firebaseStorage,
    this.firestore,
  });

  User getUser() => auth.currentUser;
  final productID = '${DateTime.now().millisecondsSinceEpoch}';

  static Box box = Hive.box('name');
  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  bool get currentUser {
    return box.get('isLoggedIn', defaultValue: false);
  }

  String get userId {
    return auth.currentUser.uid;
  }

  User get user {
    return auth.currentUser;
  }

  // Sign up User
  Future<bool> signUp({
    String email,
    String pwd,
    String fname,
    String lname,
    String phone,
    String photoUrl,
    String address,
  }) async {
    try {
      CollectionReference collectionReference = firestore.collection('Users');
      //create user on firebase auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      if (userCredential.user != null) {
        userCredential.user.sendEmailVerification();
        var userData = UserModel(
          uid: userCredential.user.uid,
          email: email,
          firstName: fname,
          lastName: lname,
          phoneNumber: phone,
          photoUrl: photoUrl,
          address: address,
        );
        await collectionReference
            .doc(userCredential.user.uid)
            .set(userData.toMap());
        // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();

        //Update display name
        await userCredential.user.updateDisplayName(
          fname + ' ' + lname,
        );
        Hive.box('name').put('displayName', user.displayName);

        Hive.box('name').put('email', userCredential.user.email);
        return true;
      }
      // return true;
    } catch (e) {
      print(e);
      FirebaseException ext = e;
      toast(ext.message);
      return false;
    }
  }

  // Sign In
  Future<bool> signIn(String email, String pwd, BuildContext context) async {
    try {
      UserCredential userCredential =
          await auth.signInWithEmailAndPassword(email: email, password: pwd);
      Hive.box('name').put('email', userCredential.user.email);
      // Get.to(BottomNav());
      return true;
    } on FirebaseAuthException catch (authException) {
      Navigator.of(context).pop();
      toast(authException.message);
      return false;
    } catch (e) {
      print(e);
      toast(e.toString());
      return false;
    }
  }

  // Determine position(Map)
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    Position currentPosition;

    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permanently denied, we cannot request permission.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // Sign in with google
  Future<bool> signInWithGoogle() async {
    CollectionReference collectionReference = firestore.collection('Users');
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
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        await collectionReference.doc(userCredential.user.uid).set({
          'fname': userCredential.user.displayName,
          'last_name': userCredential.user.displayName,
          'phone': userCredential.user.phoneNumber,
          'email': userCredential.user.email,
          'address': '',
          'photoUrl': userCredential.user.photoURL,
          'uid': userCredential.user.uid,
          'date_created': Timestamp.now(),
        });
        //Update display name
        await userCredential.user.updateDisplayName(
          userCredential.user.displayName,
        );
        Hive.box('name').put('displayName', userCredential.user.displayName);
        Hive.box('name').put('email', userCredential.user.email);
        return true;
      } else {
        toast('Google sign in failed');
        return false;
      }
    } catch (e) {
      print(e);
      toast('Google sign in failed');
      return false;
    }
  }

  // Sign in Facebook

  Future<bool> signInWithFacebook() async {
    // Trigger the sign-in flow
    CollectionReference collectionReference = firestore.collection('Users');
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken.token);

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      if (userCredential.user != null) {
        await collectionReference.doc(userCredential.user.uid).set({
          'fname': userCredential.user.displayName,
          'last_name': userCredential.user.displayName,
          'phone': userCredential.user.phoneNumber,
          'email': userCredential.user.email,
          'address': '',
          'photoUrl': userCredential.user.photoURL,
          'uid': userCredential.user.uid,
          'date_created': Timestamp.now(),
        });
        //Update display name
        await userCredential.user.updateDisplayName(
          userCredential.user.displayName,
        );
        Hive.box('name').put('displayName', userCredential.user.displayName);
        Hive.box('name').put('email', userCredential.user.email);
        return true;
      } else {
        toast('Google sign in failed');
        return false;
      }
    } catch (e) {
      print(e);
      toast('Google sign in failed');
      return false;
    }
  }

  // Reset Password
  Future<String> resetPwd(String email) async {
    var status = '';
    await auth.sendPasswordResetEmail(email: email).then((value) {
      print('Email sent successfully');
      return status = 'Email sent';
    }).catchError((e) {
      print('Error in sending email: ${e.toString()}');
      return status = e.toString();
    });
    return status;
  }

  // Change Password
  Future<bool> changePassword(String newPassword) async {
    try {
      await auth.currentUser.updatePassword(newPassword);
      successToast('Password changed successfully');
      print('Email sent successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false;
    } catch (e) {
      print(
        {e.toString()},
      );
      return false;
    }
  }

  //Update Profile
  Future<bool> updateProfile(UserModel user, BuildContext context) async {
    CollectionReference collectionReference = firestore.collection('Users');

    try {
      await auth.currentUser.updateDisplayName(
        '${user.firstName} ${user.lastName}',
      );
      await collectionReference.doc(userId).update(user.toMap());
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      successToast('Profile Updated Successfully');
      return true;
    } catch (e) {
      Navigator.of(context).pop();
      print(e.toString());

      return false;
    }
  }

  // Update Address
  Future<bool> updateDelivery(
      {String address,
      String country,
      String post,
      String city,
      String phone}) async {
    CollectionReference collectionReference = firestore.collection('Users');
    try {
      collectionReference.doc(getUser().uid).update(
        {
          'address': address,
          'postCode': post,
          'city': city,
          'country': country,
          'phoneNumber': phone,
        },
      );
      // successToast('Address changed successfully');
      return true;
    } catch (e) {
      print(e.toString());
      toast('Failed to change address');
      return false;
    }
  }

  // Update profileImage
  Future<String> updateProfileImage(File image) async {
    Reference storageReference = firebaseStorage.ref('profilePicture');
    CollectionReference collectionReference = firestore.collection('Users');
    try {
      //Upload image to firebase storage
      UploadTask uploadTask =
          storageReference.child(getUser().uid).putFile((image));
      // Get url of image
      String photoUrl;
      uploadTask.then((value) {
        value.ref.getDownloadURL().then((url) {
          photoUrl = url;
          collectionReference.doc(getUser().uid).update({
            'photoUrl': photoUrl,
            'imageUploaded': true,
          });
        });
      });
      print(photoUrl);
      return photoUrl;
    } catch (e) {
      print(e.toString());
      // toast(e.toString());
      return '';
    }
  }

//Sign out
  void signOut() async {
    await auth.signOut();
    isLoggedIn = false;
    box.put('isLoggedIn', isLoggedIn);
    await Hive.box('name').delete('fname');
    loader();
    return Get.offAll(SignInScreen());
  }

//Delete Account
  void deleteAccount() async {
    CollectionReference collectionReference = firestore.collection('Users');
    await collectionReference.doc(getUser().uid).delete();
    isLoggedIn = false;
    box.put('isLoggedIn', isLoggedIn);
    await Hive.box('name').clear();
    loader();
    return Get.offAll(SignInScreen());
  }

// Get user details
  Future<Map> getUserDetails() async {
    CollectionReference userCredential = firestore.collection('Users');
    try {
      DocumentSnapshot shot = await userCredential.doc(getUser().uid).get();
      print('User details ${shot}');

      return shot.data();
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  /// stream userdetails
  Stream<DocumentSnapshot> userDetails() {
    CollectionReference collectionReference = firestore.collection('Users');
    try {
      var snap = collectionReference.doc(getUser().uid).snapshots();
      print('User details ${snap}');
      // return shot.data();
      return snap;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Future<UserModel> getUserCurrentUserData() async {
  //   try {
  //     var userData =
  //         await firestore.collection('Users').doc(auth.currentUser.uid).get();
  //     UserModel user;
  //     if (userData.data() != null) {
  //       user = UserModel.fromMap(userData.data());
  //     }
  //     print('User ${user}');
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

// Send Email Verification
  void sendVerificationEmail() async {
    await auth.currentUser.sendEmailVerification();
    successToast("Verification email sent");
  }
}


//  Stream<UserModel> userData(String userId) {
//     return firestore.collection('users').doc(userId).snapshots().map(
//           (event) => UserModel.fromMap(
//             event.data()!,
//           ),
//         );
//   }
