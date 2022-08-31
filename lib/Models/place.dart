import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation({
    this.latitude,
    this.longitude,
    this.address,
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    this.id,
    this.title,
    this.location,
    this.image,
  });
}
