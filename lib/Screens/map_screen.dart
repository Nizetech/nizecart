import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/place.dart';

class MapScreen extends StatefulWidget {
  final bool isSelecting;
  MapScreen({
    // this.initialLocation,
    //  = const PlaceLocation(
    //   latitude: 6.447260,
    //   longitude: 5.797580,
    //   // address: 'Unknown Place',
    // ),
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng pickedLocation;
  void selectLocation(LatLng position) {
    setState(() {
      pickedLocation = position;
    });
  }

  GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static const CameraPosition initialLocation = CameraPosition(
    target: LatLng(
      6.3344143,
      5.5998271,
    ),
    zoom: 11,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            title: Text('Map'),
            actions: [
              if (widget.isSelecting)
                IconButton(
                  onPressed: pickedLocation == null ? null : () => Get.back(),
                  icon: Icon(Icons.check),
                ),
            ]),
        body: GoogleMap(
          // mapType: MapType.hybrid,
          onMapCreated: onMapCreated,
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
        ));
  }
}
