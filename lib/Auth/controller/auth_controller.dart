import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';

import '../../Models/user_model.dart';

final authtControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authtControllerProvider);
  return authController.userDetails();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    this.authRepository,
    this.ref,
  });

// Sign up
  Future<bool> signUp(
    String email,
    String pwd,
    String fname,
    String lname,
    String phone,
  ) {
    return authRepository.signUp(
      email: email,
      pwd: pwd,
      fname: fname,
      lname: lname,
      phone: phone,
    );
  }

// Sign In
  Future<bool> signIn(String email, String pwd, BuildContext context) {
    return authRepository.signIn(email, pwd, context);
  }

  // SignIn with google
  Future<bool> signInWithGoogle() {
    return authRepository.signInWithGoogle();
  }

  // SignIn with facebook
  Future<bool> signInWithFacebook() {
    return authRepository.signInWithFacebook();
  }

  // Sign out
  void signOut() {
    authRepository.signOut();
  }

  // Delete Account
  void deleteAccount() {
    authRepository.deleteAccount();
  }

  // Change Password
  Future<bool> changePassword(String newPassword) {
    return authRepository.changePassword(newPassword);
  }

  // Change Password
  Future<bool> ChangeDisplayName(String newName) {
    return authRepository.changeDisplayName(newName);
  }

  // Change Password
  Future<bool> changePhoneNumber(String phoneNumber) {
    return authRepository.changePhoneNumber(phoneNumber);
  }

  // Reset password
  Future<String> resetPwd(String email) {
    return authRepository.resetPwd(email);
  }

  // Change Address
  Future<bool> updateDelivery(
      {String address, String state, String post, String lga, String phone}) {
    return authRepository.updateDelivery(
      address: address,
      state: state,
      lga: lga,
      post: post,
      phone: phone,
    );
  }

  // Update ProfileImage
  void updateProfileImage(File image) {
    authRepository.updateProfileImage(image);
  }

  // get Userdetails
  Future<Map> getUserDetails() {
    return authRepository.getUserDetails();
  }

  // Get UserData
  // Future<UserModel> getUserCurrentUserData() async {
  //   UserModel user = await authRepository.getUserCurrentUserData();
  //   return user;
  // }

  // Determine Position(Map)
  Future<Position> determinePosition() {
    return authRepository.determinePosition();
  }

//Get Stream userDetails
  Stream<DocumentSnapshot> userDetails() {
    return authRepository.userDetails();
  }
  // GetCurrentUser
//   Future<void> getUserDetails() {
//     return authRepository.getUserDetails();
//   }
}
