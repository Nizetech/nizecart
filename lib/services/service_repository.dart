import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';

final serviceRepositoryProvider =
    Provider((ref) => ServiceRepository(ref: ref));

class ServiceRepository {
  final ProviderRef ref;

  ServiceRepository({this.ref});

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
}
