import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:nizecart/keys/keys.dart';

final serviceRepositoryProvider = Provider((ref) => ServiceRepository(
      ref: ref,
      auth: FirebaseAuth.instance,
    ));

class ServiceRepository {
  final ProviderRef ref;
  final FirebaseAuth auth;

  ServiceRepository({
    this.ref,
    this.auth,
  });
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getUserAddress() async {
    try {
      Position position = await determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Hive.box('name').put('lat', position.latitude);
      Hive.box('name').put('lng', position.longitude);
      print('my latitutde ${position.latitude}');
      print('my longitude ${position.longitude}');

      Placemark place = placemarks[0];

      final address =
          ' ${place.street},${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      return address;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

//Save user fcm token
  void saveToken(String token) {
    Hive.box('name').put('token', token);
    users.doc(auth.currentUser.uid).update({'token': token});
  }

  //Send Message(Notification)
  void sendMessage({String token, Map<String, dynamic> message}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmKey',
        },
        body: json.encode({
          'to': token,
          'notification': {
            'title': message['title'],
            'body': message['body'],
          },
          'date': {'id': message['id']},
        }),
      );
      await saveNotif(
        message,
        // userId: message['uid']
      );
    } catch (e) {
      print(e.toString());
    }
  }

  //Save Notifications
  Future<void> saveNotif(Map<String, dynamic> message, {String userId}) async {
    await users
        .doc(userId ?? auth.currentUser.uid)
        .collection('Notifications')
        .add(message);
  }

  //Get user notifications
  Future<List> getNotifs() async {
    try {
      QuerySnapshot snap = await users
          .doc(auth.currentUser.uid)
          .collection('Notificstions')
          .get();
      return snap.docs.map((e) => e.data()).toList();
    } catch (e) {
      return [];
    }
  }
}
