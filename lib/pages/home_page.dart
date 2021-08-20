import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:with_app/components/bottom_modal_sheet.dart';
import 'package:with_app/components/map_overlay.dart';
import 'package:with_app/pages/network_player_widget.dart';
import 'package:with_app/pages/users_profile_page.dart';
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

  GlobalKey _globalKey = new GlobalKey();

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Widget widgetToImage(BuildContext context) {
    return ClipRRect(
      key: _globalKey,
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        "assets/images/user_avatar.jpg",
        height: 150.0,
        width: 100.0,
      ),
    );
  }

  void getPermissions()async{
    var permission = Permission.location;


    var permissionStatus = await permission.request();

    print("isGranted: " +
        permissionStatus.isGranted.toString() +
        " isDenied: " +
        permissionStatus.isDenied.toString() +
        " isLimited: " +
        permissionStatus.isLimited.toString() +
        " isRestricted: " +
        permissionStatus.isRestricted.toString() +
        " isPermanentlyDenied: " +
        permissionStatus.isPermanentlyDenied.toString());
  }


  @override
  void initState() {
    super.initState();
    getPermissions();
    _getUserLocation();
    setCustomMapPin();
    // Marker testMarker = Marker(
    //     position: LatLng(31.4940658,74.3736309),
    //     markerId: MarkerId(LatLng(31.4940658,74.3736309).toString()),
    //     icon: BitmapDescriptor.defaultMarker
    // );
    // setState(() {
    //   _markers.add(testMarker);
    // });
    getAllPosts(context);
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
              refreshTap: () {
                setState(() {
                  _markers.clear();
                });
                getAllPosts(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> getAllPosts(BuildContext context) async {
    CollectionReference _documentRef =
        FirebaseFirestore.instance.collection("timeline");
    await _documentRef.get().then(
      (ds) {
        if (ds != null) {
          ds.docs.forEach(
            (QueryDocumentSnapshot snapshot) {
              initMarkers(snapshot, snapshot.id, context);
            },
          );
        }
      },
    );
  }

  initMarkers(doc, docId,BuildContext context) {
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
            height: Styles.height(context) * 0.8,
            context: context,
            kChild: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
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
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UsersProfilePage(
                                    uid: doc['userId'],
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    doc['userImg'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
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
                          ),
                          SizedBox(
                            width: Styles.width(context) * 0.04,
                          ),
                          Expanded(
                            child: Text(
                              doc['userName'],
                              style: cTextStyleBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Styles.width(context) * 0.01,
                    ),
                    doc['desc'] != null
                        ? AutoSizeText(
                          doc['desc'].toString(),
                          maxLines: 2,
                        )
                        : SizedBox(),
                    SizedBox(
                      width: Styles.width(context) * 0.01,
                    ),
                    Expanded(
                        child: doc['format'] == 'image'
                            ? Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(doc['url'])),
                                  color: Colors.black,
                                ),
                              )
                            : Container(
                                color: Colors.black,
                                child: NetworkPlayerWidget(
                                  url: doc['url'],
                                ),
                              )),
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

  void _getUserLocation() async {
    var position = await geoLocator.GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: geoLocator.LocationAccuracy.bestForNavigation);

    setState(() {
      double userLat = position.latitude;
      double userLng = position.longitude;
      _initialCameraPosition = LatLng(userLat,userLng);
      print("These are coordinates: $userLat $userLng");
    });
  }

  // getLoc() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //
  //   _currentPosition = await location.getLocation();
  //
  //   _initialCameraPosition =
  //       LatLng(_currentPosition.latitude, _currentPosition.longitude);
  //
  //   moveCameraToMyLocation();
  // }
}
