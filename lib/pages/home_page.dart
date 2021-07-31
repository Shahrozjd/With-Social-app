import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:with_app/components/bottom_modal_sheet.dart';
import 'package:with_app/components/map_overlay.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:location/location.dart';
import 'package:with_app/styles/styles.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;
  final Set<Marker> _markers = {};
  Location location = Location();
  LocationData _currentPosition;

  GoogleMapController _controller;
  LatLng _initialCameraPosition = LatLng(0.5937, 0.9629);
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor postLocationIcon;

  @override
  void initState() {
    super.initState();
    getLoc();
    setCustomMapPin();
    // Marker testMarker = Marker(
    //     position: LatLng(31.4940658,74.3736309),
    //     markerId: MarkerId(LatLng(31.4940658,74.3736309).toString()),
    //     icon: BitmapDescriptor.defaultMarker
    // );
    // setState(() {
    //   _markers.add(testMarker);
    // });
    getAllPosts();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/user_location.png');

    postLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/user_marker.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialCameraPosition, zoom: 15),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
            ),
            MapOverlay(
              onRelocateTap: moveCameraToMyLocation,
            )
          ],
        ),
      ),
    );
  }

  Future<void> getAllPosts() async {
    CollectionReference _documentRef =
        FirebaseFirestore.instance.collection("timeline");
    await _documentRef.get().then(
      (ds) {
        if (ds != null) {
          ds.docs.forEach(
            (QueryDocumentSnapshot snapshot) {
              initMarkers(snapshot, snapshot.id);
            },
          );
        }
      },
    );
  }

  initMarkers(doc, docId) {
    double lat = doc['lat'];
    double lng = doc['lng'];
    LatLng postPosition = LatLng(lat, lng);
    Marker postMarker = Marker(
      markerId: MarkerId(docId),
      draggable: false,
      position: postPosition,
      icon: postLocationIcon != null
          ? postLocationIcon
          : BitmapDescriptor.defaultMarker,
      onTap: () {
        bottomModalSheet(
            height: Styles.height(context) * 0.7,
            context: context,
            kChild: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            height: 55.0,
                            width: 55.0,
                            child: Center(child: Icon(FontAwesome.user)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5.0,
                                    offset: Offset(3, 3),
                                    spreadRadius: 1.0)
                              ],
                            ),
                            duration: Duration(milliseconds: 400),
                          ),
                          SizedBox(
                            width: Styles.width(context) * 0.04,
                          ),
                          Expanded(
                            child: Text(
                              "John Doe",
                              style: cTextStyleBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(doc['url']),
                              )
                            ),
                        ),),
                  ],
                ),
              ),
            ));
      },
    );
    setState(() {
      print("MARKER ADDED");
      _markers.add(postMarker);
    });
  }

  Future<void> _onMapCreated(GoogleMapController _cntlr) async {
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialCameraPosition, zoom: 15),
      ),
    );
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/files/map_style.json');
    _controller.setMapStyle(value);
  }

  void moveCameraToMyLocation() {
    _controller.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: _initialCameraPosition,
          zoom: 15.0,
        ),
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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

    _currentPosition = await location.getLocation();

    _initialCameraPosition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);

    moveCameraToMyLocation();
  }
}
