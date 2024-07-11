import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationAttendanceScreen extends StatefulWidget {
  const LocationAttendanceScreen(
      {super.key, required this.lat, required this.lng});

  final double lat;
  final double lng;

  @override
  State<LocationAttendanceScreen> createState() =>
      _LocationAttendanceScreenState();
}

class _LocationAttendanceScreenState extends State<LocationAttendanceScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    print(widget.lat);
    print(widget.lng);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Location'),
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(widget.lat, widget.lng),
            zoom: 19.151926040649414,
          ),
          markers: {
            Marker(
              markerId: MarkerId('attendance Location'),
              position: LatLng(widget.lat, widget.lng),
            )
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
