import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nizecart/Widget/component.dart';
import 'place.dart';

class MapScreen extends StatefulWidget {
  final bool isSelecting;
  static const DefaultZoom = 18.4;
  static const MyLocation = LatLng(
    6.447260,
    5.797580,
  );
  double initZoom;
  LatLng initCoordinates;

  LatLng value;

  MapScreen({
    this.initZoom = DefaultZoom,
    this.initCoordinates = MyLocation,
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController address = TextEditingController();
  LatLng pickedLocation;

  final Completer<GoogleMapController> mapController = Completer();
  void selectLocation(LatLng position) {
    setState(() {
      pickedLocation = position;
    });
  }

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

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  static const CameraPosition initialLocation = CameraPosition(
    target: LatLng(
      6.3344143,
      5.5998271,
    ),
    zoom: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[300],
          actions: [
            if (widget.isSelecting)
              IconButton(
                onPressed: pickedLocation == null ? null : () => Get.back(),
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
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  'Hi nice to meet you!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
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
                  onMapCreated: onMapCreated,
                  onCameraMove: (CameraPosition newPosition) {
                    print(newPosition.target.toJson());
                    widget.value = newPosition.target;
                  },
                  myLocationEnabled: true,
                  indoorViewEnabled: true,
                  initialCameraPosition: initialLocation,
                  onTap: widget.isSelecting ? selectLocation : null,
                  markers: (pickedLocation == null && widget.isSelecting)
                      ? {}
                      : {
                          Marker(
                            markerId: MarkerId('m1'),
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
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: 'Submit',
                  onPressed: () {},
                ),
              )
            ],
          ),
        ));
  }
}
