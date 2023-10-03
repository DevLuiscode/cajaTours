import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

class MapsScreen extends StatefulWidget {
  final double lat;
  final double lng;
  MapsScreen({
    required this.lat,
    required this.lng,
  });

  @override
  State<MapsScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  loc.LocationData? _currentPosition;
  LatLng curLocation = LatLng(-7.148863, -78.506861);
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourcePosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: curLocation,
                    zoom: 15,
                  ),
                  markers: {sourcePosition!, destinationPosition!},
                  onTap: (latLng) {},
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: 50,
                  left: 25,
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Positioned(
                    bottom: 13,
                    right: 13,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.navigation_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            String googleMapsUrl =
                                'https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}';
                            String appleMapsUrl =
                                'https://maps.apple.com/?q=${widget.lat},${widget.lng}';

                            if (await launchUrl(Uri.parse(googleMapsUrl))) {
                              await launchUrl(Uri.parse(googleMapsUrl));
                            } else if (await launchUrl(
                                Uri.parse(appleMapsUrl))) {
                              await launchUrl(Uri.parse(appleMapsUrl));
                            } else {
                              throw 'Could not launch URL';
                            }
                          },
                        ),
                      ),
                    ))
              ],
            ),
    );
  }

  getNavigation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      locationSubscription = location.onLocationChanged.listen(
        (LocationData currentLocation) {
          controller
              ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 13,
          )));
          // if (mounted) {
          //   controller?.showMarkerInfoWindow(
          //       MarkerId(sourcePosition!.markerId.value));
          //   setState(() {
          //     curLocation =
          //         LatLng(currentLocation.latitude!, currentLocation.longitude!);
          //     sourcePosition = Marker(
          //       markerId: MarkerId(currentLocation.toString()),
          //       icon: BitmapDescriptor.defaultMarkerWithHue(
          //           BitmapDescriptor.hueBlue),
          //       position: LatLng(
          //           currentLocation.latitude!, currentLocation.longitude!),
          //       infoWindow: InfoWindow(
          //           title:
          //               '${double.parse((getDistance(LatLng(widget.lat, widget.lng)).toStringAsFixed(2)))} km'),
          //       onTap: () {
          //         print('market tapped---------------');
          //       },
          //     );
          //   });
          //   getDirections(LatLng(widget.lat, widget.lng));
          // }
          if (mounted) {
            setState(() {
              curLocation =
                  LatLng(currentLocation.latitude!, currentLocation.longitude!);
              sourcePosition = Marker(
                markerId: const MarkerId(
                    'source'), // Asegúrate de que este ID es único y válido
                position: curLocation,
                infoWindow: InfoWindow(
                  title:
                      '${double.parse((getDistance(LatLng(widget.lat, widget.lng)).toStringAsFixed(2)))} km',
                ),
                onTap: () {
                  print('Marker tapped');
                },
              );
            });

            // Asegúrate de que tu marcador ha sido añadido al mapa antes de intentar mostrar su ventana de información
            Future.delayed(const Duration(seconds: 1), () async {
              if (mounted) {
                controller?.showMarkerInfoWindow(const MarkerId('source'));
              }
            });
            getDirections(LatLng(widget.lat, widget.lng));
          }
        },
      );
    }
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyDEH_ccxDicPoq8STd8Imfb2JE2YOYJjWw',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      print('-------------${result.errorMessage}');
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }

  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(widget.lat, widget.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }
}
