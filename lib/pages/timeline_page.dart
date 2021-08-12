import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:with_app/components/CustomTextField.dart';
import 'package:with_app/components/bottom_modal_sheet.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/components/toaster.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/network_player_widget.dart';
import 'package:with_app/pages/users_profile_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class TimelinePage extends StatefulWidget {
  static const String id = 'TimelinePage';

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final controller = ScrollController();
  Stream timelineStream;
  String gender;
  double userLat, userLng;

  Future<void> getFirestoreData() async {
    await FireCollection.userDoc()
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          gender = snapshot['gender'].toString();
          if (gender == 'male') {
            timelineStream = FireCollection.timelineCollection()
                .where("type", isNotEqualTo: 'female')
                .snapshots();
          } else if (gender == "female") {
            timelineStream = FireCollection.timelineCollection()
                .where("type", isNotEqualTo: 'male')
                .snapshots();
          } else {
            timelineStream = FireCollection.timelineCollection().snapshots();
          }
        });
      }
    });
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userLat = position.latitude;
      userLng = position.longitude;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double distance = 12742 * asin(sqrt(a));
    print(distance);
    return distance;
  }

  @override
  void initState() {
    _getUserLocation();
    getFirestoreData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: ScrollAppBar(
        controller: controller,
        title: Text(
          "Feed",
          style: cTextStyleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: timelineStream != null
              ? StreamBuilder<QuerySnapshot>(
                  stream: timelineStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CustomLoading(),
                      );
                    }
                    if (snapshot.data.size == 0) {
                      return Center(
                        child: Text(
                          'No Post Yet',
                          style: cTextStyleMedium,
                        ),
                      );
                    }

                    return Snap(
                      controller: controller.appBar,
                      child: ListView(
                        controller: controller,
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        children: snapshot.data.docs.map(
                          (DocumentSnapshot document) {
                            if (calculateDistance(userLat, userLng,
                                    document['lat'], document['lng']) <=
                                25) {
                              return PostCards(
                                imagePath: document['url'].toString(),
                                format: document['format'].toString(),
                                desc: document['desc'],
                                userName: document['userName'],
                                docId: document.id,
                                userId: document['userId'],
                                userImg: document['userImg'],
                                lat: document['lat'],
                                lng: document['lng'],
                              );
                            }
                            return SizedBox();
                          },
                        ).toList(),
                      ),
                    );
                  },
                )
              : CustomLoading(),
        ),
      ),
    );
  }
}

class PostCards extends StatefulWidget {
  String imagePath, format, docId, desc, userName, userId, userImg;
  double lat, lng;

  PostCards(
      {this.imagePath,
      this.format,
      this.docId,
      this.desc,
      this.userName,
      this.userId,
      this.userImg,
      this.lat,
      this.lng});

  @override
  _PostCardsState createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  var userLoc;

  @override
  void initState() {
    _getLocation(widget.lat, widget.lng);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Styles.height(context) * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.2, color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsersProfilePage(
                                uid: widget.userId,
                              ),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          height: 55.0,
                          width: 55.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber,
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.userImg,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              widget.userName,
                              style: cTextStyleBold,
                            ),
                            Text(
                              userLoc == null ? "..." : userLoc.toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String reportText;
                    bottomModalSheet(
                      context: context,
                      height: Styles.height(context) * 0.3,
                      kChild: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Report Post?",
                              style: cTextStyleMediumBold,
                            ),
                            CustomTextField(
                              hinText: "Write little about report",
                              obscureText: false,
                              onChanged: (String getReport) {
                                reportText = getReport;
                              },
                            ),
                            RoundRectButton(
                              text: 'SAVE',
                              height: 40,
                              onPress: () async {
                                if (reportText != null) {
                                  await FirebaseFirestore.instance
                                      .collection('timeline')
                                      .doc(widget.docId)
                                      .collection('report')
                                      .doc()
                                      .set({
                                    'desc': reportText,
                                    'timestamp': FieldValue.serverTimestamp(),
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Toaster.showToast(
                                        "Report added successfully",
                                        ToastGravity.TOP);
                                  }).catchError((e) =>
                                          print("Error while adding post"));
                                } else {
                                  Toaster.showToast(
                                      "Please write little about report",
                                      ToastGravity.TOP);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(FontAwesome5.exclamation_circle),
                )
              ],
            ),
          ),
          SizedBox(
            width: Styles.width(context) * 0.01,
          ),
          widget.desc != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: AutoSizeText(
                    widget.desc,
                    maxLines: 1,
                  ),
                )
              : SizedBox(),
          SizedBox(
            width: Styles.width(context) * 0.02,
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: widget.format == 'image'
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.imagePath)),
                          color: Colors.black,
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NetworkPlayerWidget(
                              url: widget.imagePath,
                            ),
                          ],
                        ),
                      )
                // VideoItem(
                //   videoPlayerController: VideoPlayerController.network(imagePath),
                //   looping: false,
                //   autoplay: false,
                // ),
                ),
          )
        ],
      ),
    );
  }

  Future<void> _getLocation(double lat, double lng) async {
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.locality} , ${first.countryCode}");
    setState(
      () {
        userLoc = "${first.locality}, ${first.countryCode}";

      },
    );
  }
}
