import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestMapPage extends StatefulWidget {
  const TestMapPage({Key key}) : super(key: key);

  @override
  _TestMapPageState createState() => _TestMapPageState();
}

class _TestMapPageState extends State<TestMapPage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(37.785834, -122.406417);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test Maps'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
