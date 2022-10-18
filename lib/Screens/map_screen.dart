import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Screens/delivery_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'place.dart';

class MapScreen extends StatefulWidget {
  final String loc;
  final bool isSelecting;
  static const DefaultZoom = 18.4;
  // static const MyLocation = LatLng(
  //   6.447260,
  //   5.797580,
  // );
  double initZoom;
  LatLng initCoordinates;

  LatLng value;

  MapScreen({
    this.loc,
    this.initZoom = DefaultZoom,
    // this.initCoordinates = MyLocation,
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController address = TextEditingController();
  static var box = Hive.box('name');

  @override
  void initState() {
    address.text = widget.loc;
    super.initState();
  }

  LatLng pickedLocation;

  // final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController mapController;

  // GoogleMapController mapController;

// Used to translate address to longitude AND latitude
// List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");

// Used longitude AND latitude into address
// List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);

  Future<Position> _determinePosition() async {
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

  String newLocation = '';

  void selectLocation(LatLng position) async {
    setState(() {
      pickedLocation = position;
      log('my Latitude ${pickedLocation.latitude}');
      log('my longitude ${pickedLocation.longitude}');
    });
    await _getUserAddress(pickedLocation).then((value) {
      setState(() {
        newLocation = value;
        address.text = newLocation;
      });
    });
    log('my Address $newLocation');
  }

  // Future<Position> selectLocation(LatLng position) async {
  //   LatLng pickedLocation;
  //   setState(() {
  //     pickedLocation = position;
  //     log('my Latitude ${pickedLocation.latitude}');
  //     log('my longitude ${pickedLocation.longitude}');
  //   });
  //   return pickedLocation;
  // }
  // void onMapCreated(GoogleMapController controller) {
  // mapController.complete(controller);
  // }

  //       var position = await _determinePosition();
  //       final GoogleMapController controller =
  //           await mapController.future;
  //       controller.showMarkerInfoWindow(
  //         MarkerId('m2'),
  //       );
  //       controller.getScreenCoordinate(
  //         LatLng(position.latitude, position.longitude),
  //       );

  //       controller.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(
  //                 position.latitude, position.longitude),
  //             zoom: widget.initZoom,
  //           ),
  //         ),
  //       );

  Future<String> _getUserAddress(pickedLocation) async {
    try {
      // Position pickedLocation = await _determinePosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
          pickedLocation.latitude, pickedLocation.longitude);

      Placemark place = placemarks[0];

      final address =
          ' ${place.street},${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      return address;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  Position position;

  static double lat = box.get('lat', defaultValue: 6.447260);
  static double lng = box.get('lng', defaultValue: 5.797580);

  CameraPosition initialLocation = CameraPosition(
    target: LatLng(
      // position.latitude,
      // 6.447260,
      lat,
      // position.longitude,
      // 5.797580,
      lng,
    ),
    zoom: 18,
  );

  Map userData = box.get('userData', defaultValue: {});
  int locAmount = box.get('locAmount');

  final Set<Marker> markers = new Set();
  // Set<Marker> getmarkers() { //markers to place on map
  // setState(() {
  // markers.add(
  //   Marker( //add first marker
  //   markerId: MarkerId(showLocation.toString()),
  //   position: showLocation, //position of marker
  //   infoWindow: InfoWindow( //popup info
  //     title: 'Marker Title First ',
  //     snippet: 'My Custom Subtitle',
  //   ),
  //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
  // ));

//     });

//     return markers;
//   }
// }

  @override
  Widget build(BuildContext context) {
    // log('static: $userData ');
    // log('static: $locAmount ');
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          actions: [
            if (widget.isSelecting)
              IconButton(
                onPressed: pickedLocation == null
                    ? null
                    : () => Navigator.of(context).pop(),
                icon: Icon(Icons.check),
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 100,
                alignment: Alignment.center,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Hi nice to meet you!🤗',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tap to select new location ',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: mainColor),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .5,
                width: double.infinity,
                child:
                    //  Stack(
                    //   children: [
                    GoogleMap(
                  // mapType: MapType.hybrid,
                  onMapCreated:
                      // onMapCreated,
                      (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  onCameraMove: (CameraPosition newPosition) {
                    // print(newPosition.target.toJson());
                    // widget.value = newPosition.target;
                    _determinePosition();
                  },
                  myLocationEnabled: true,
                  indoorViewEnabled: true,
                  initialCameraPosition: initialLocation,
                  onTap:
                      //  widget.isSelecting
                      //     ?

                      selectLocation,
                  // :
                  // null,
                  markers: (pickedLocation == null)
                      ? {
                          Marker(
                            infoWindow:
                                InfoWindow(title: 'My current location'),
                            markerId: MarkerId('m1'),
                            position: pickedLocation ??
                                LatLng(
                                  initialLocation.target.latitude,
                                  initialLocation.target.longitude,
                                ),
                          ),
                        }
                      : {
                          Marker(
                            infoWindow: InfoWindow(title: 'New location'),
                            markerId: MarkerId('m2'),
                            position: pickedLocation ??
                                LatLng(
                                  initialLocation.target.latitude,
                                  initialLocation.target.longitude,
                                ),
                          ),
                        },
                ),
                // Positioned(
                //     bottom: 30,
                //     left: 30,
                //     child:
                // Container(
                //   color: Colors.white,
                //   child: IconButton(
                //     icon: Icon(Icons.my_location),
                //     onPressed: () async {

                //       var position = await _determinePosition();
                //       final GoogleMapController controller =
                //           await mapController.future;
                //       controller.showMarkerInfoWindow(
                //         MarkerId('m2'),
                //       );
                //       controller.getScreenCoordinate(
                //         LatLng(position.latitude, position.longitude),
                //       );

                //       controller.animateCamera(
                //         CameraUpdate.newCameraPosition(
                //           CameraPosition(
                //             target: LatLng(
                //                 position.latitude, position.longitude),
                //             zoom: widget.initZoom,
                //           ),
                //         ),
                //       );
                //   },
                // ),
                // ))
                //   ],
                // ),
              ),
              CustomTextField(
                controller: address,
                hint: 'Address',
                enable: false,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                    text: 'Submit',
                    onPressed: () {
                      print('my amount: $locAmount');
                      // print('my user: $locUser');
                      Get.to(DeliveryScreen(
                        user: userData,
                        totalAmount: locAmount,
                        location: address.text,
                      ));
                    }),
              )
            ],
          ),
        ));
  }
}
