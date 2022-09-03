import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';

final authtControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
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
  Future<bool> signIn(String email, String pwd) {
    return authRepository.signIn(email, pwd);
  }

  // SignIn with google
  Future<bool> signInWithGoogle() {
    return authRepository.signInWithGoogle();
  }

  // Sign out
  void signOut() {
    authRepository.signOut();
  }

  // Change Password
  Future<bool> changePassword(String newPassword) {
    return authRepository.changePassword(newPassword);
  }

  // Reset password
  Future<String> resetPwd(String email) {
    return authRepository.resetPwd(email);
  }

  // Change Address
  Stream<void> changeAddress(String address) {
    return authRepository.changeAddress(address);
  }

  // Update ProfileImage
  void updateProfileImage(File image) {
    authRepository.updateProfileImage(image);
  }

  // get Userdetails
  Future<Map> getUserDetails() {
    return authRepository.getUserDetails();
  }

  // Determine Position(Map)
  Future<Position> determinePosition() {
    return authRepository.determinePosition();
  }

  // GetCurrentUser
//   Future<void> getUserDetails() {
//     return authRepository.getUserDetails();
//   }
}
