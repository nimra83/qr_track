import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  static String routename = "/location";

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LatLng? _currentPosition;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (isLocationEnabled) {
        try {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            _isLoading = false;
          });

          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition!, zoom: 14),
          ));
        } catch (e) {
          setState(() {
            _isLoading = false;
            _error = 'Failed to get location: $e';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Location services are disabled.';
        });
      }
    } else if (permission.isDenied) {
      setState(() {
        _isLoading = false;
        _error = 'Location permission denied.';
      });
    } else if (permission.isPermanentlyDenied) {
      setState(() {
        _isLoading = false;
        _error = 'Location permission permanently denied. Please enable it in the settings.';
      });
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Location permission status: $permission';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Current Location'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : GoogleMap(
          initialCameraPosition: CameraPosition(target: _currentPosition ?? const LatLng(0, 0)),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _currentPosition != null
              ? {
            Marker(
              markerId: MarkerId('currentLocation'),
              position: _currentPosition!,
            ),
          }
              : {},
        ),
      ),
    );
  }
}
