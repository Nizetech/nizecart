import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  Future<Position> determinePosition() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return Future.error(
          'Location permission are permanently denied, we cannot request permission.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddress() async {
    try {
      Position position = await determinePosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      final address = '${place.administrativeArea}, ${place.country}';
      return address;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }
}
