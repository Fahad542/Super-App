

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class geotag extends StatefulWidget {
  String? lat;
  String? lon;
  geotag({Key? key, this.lat, this.lon}) : super(key: key);

  @override
  State<geotag> createState() => _geotagState();
}

class _geotagState extends State<geotag> {
  // Set your initial map position
  late CameraPosition initialPosition;

  @override
  void initState() {
    super.initState();
    initialPosition = CameraPosition(
      target: LatLng(double.parse(widget.lat!), double.parse(widget.lon!)),
      zoom: 12.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map")),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        markers: Set<Marker>.from([
          Marker(
            markerId: MarkerId('your_marker_id'),
            position: LatLng(double.parse(widget.lat!), double.parse(widget.lon!)),
            infoWindow: InfoWindow(
              title: 'Your Location',
            ),
          ),
        ]),
      ),
    );
  }
}
