import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/image_input.dart';
import 'package:nizecart/bottonNav.dart';

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
      CollectionReference userCredential = firestore.collection('Users');
      //create user on firebase auth
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      if (user.user != null) {
        user.user.sendEmailVerification();
        var userData = UserModel(
          uid: user.user.uid,
          email: email,
          fname: fname,
          lname: lname,
          phone: phone,
          photoUrl: photoUrl,
          address: address,
        );
        await userCredential.doc(user.user.uid).set(userData.toMap());
        // QueryDocumentSnapshot shot = await firestore.collection('Admin').get();
        Hive.box('name').put('displayName', fname);
        Hive.box('name').put('lname', lname);
        Hive.box('name').put('email', user.user.email);
        return true;
      }
      // return true;
    } catch (e) {
      print(e);
      FirebaseException ext = e;
      showErrorToast(ext.message);
      return false;
    }
  }

  // Sign In
  Future<bool> signIn(String email, String pwd) async {
    try {
      UserCredential user =
          await auth.signInWithEmailAndPassword(email: email, password: pwd);
      Hive.box('name').put('email', user.user.email);
      Get.to(BottomNav());
      return true;
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
    CollectionReference userCredential = firestore.collection('Users');
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
        await userCredential.doc(user.user.uid).set({
          'fname': user.user.displayName,
          'last_name': user.user.displayName,
          'phone': user.user.phoneNumber,
          'email': user.user.email,
          'uid': user.user.uid,
          'date_created': Timestamp.now(),
        });
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
      showToast('Password changed successfully');
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

  // Update Address
  Stream<void> changeAddress(String address) {
    CollectionReference userCredential = firestore.collection('Users');
    try {
      userCredential.doc(getUser().uid).update(
        {
          'address': address,
        },
      );
      showToast('Address changed successfully');
    } catch (e) {
      print(e.toString());
      showErrorToast('Failed to change address');
    }
  }

  // Update profileImage
  void updateProfileImage(File image) async {
    Reference storageReference = firebaseStorage.ref('profilePicture');
    CollectionReference userCredential = firestore.collection('Users');
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
            'photoUrl': photoUrl,
            'imageUploaded': true,
          });
        });
      });
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

//Sign out
  void signOut() async {
    await auth.signOut();
    isLoggedIn = false;
    box.put('isLoggedIn', isLoggedIn);
    await Hive.box('name').delete('fname');
    loader();
    return Get.to(SignInScreen());
  }

// Get user details
  Future<Map> getUserDetails() async {
    CollectionReference userCredential = firestore.collection('Users');
    DocumentSnapshot shot = await userCredential.doc(getUser().uid).get();
    print(shot);
    return shot.data();
  }

// Send Email Verification
  void sendVerificationEmail() async {
    await auth.currentUser.sendEmailVerification();
    showToast("Verification email sent");
  }
}

 // //Get displayName
  // Future<String> getProduct() async {
  //   QuerySnapshot snapshot =
  //       await userCredential.where('uid', isEqualTo: productID).get();
  //   List<QueryDocumentSnapshot> docs = snapshot.docs;
  //   String data = docs[0].data();
  //   return data;
  // }