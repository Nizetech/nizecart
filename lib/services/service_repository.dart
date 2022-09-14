import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceRepositoryProvider = Provider((ref) => ServiceRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class ServiceRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  ServiceRepository({this.auth, this.firestore});
}
