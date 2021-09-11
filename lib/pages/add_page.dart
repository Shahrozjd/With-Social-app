import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:with_app/components/CustomTextField.dart';
import 'package:with_app/components/bottom_modal_sheet.dart';
import 'package:with_app/components/round_rect_button_child.dart';
import 'package:with_app/components/toaster.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class AddPage extends StatefulWidget {
  static const String id = 'AddPage';

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String imageName,
      imageUrl,
      _gender,
      videoName,
      videoUrl,
      fName,
      lName,
      userImg;
  String desc;
  File getVideo;
  File getImage;
  bool isLoading = false;
  List<String> genderList = [
    'everyone',
    'male',
    'female',
  ];

  Location location = Location();
  LocationData _currentPosition;

  Future<void> getFirestoreData() async {
    setState(() {
      isLoading = true;
    });
    await FireCollection()
        .userDoc()
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          fName = snapshot['firstName'];
          lName = snapshot['lastName'];
          userImg = snapshot['image'];
          isLoading = false;
        });
      }
    });
  }

  void getPermissions() async {
    var permission =
        Platform.isAndroid ? Permission.storage : Permission.photos;

    var permissionStatus = await permission.request();

    if (permissionStatus.isPermanentlyDenied) {
      Permission.photos.request();
    }

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
    getPermissions();
    getFirestoreData();
    _gender = genderList[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ContentCards(
                    title: 'Add Video',
                    imgPath: "assets/images/add_video_img.png",
                    onpress: () {
                      bottomModalSheet(
                        height: Styles.height(context) * 0.5,
                        context: context,
                        kChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundRectButtonChild(
                                height: 50,
                                backgroundColor: Colors.grey[500],
                                child: videoName == null
                                    ? Text(
                                        "Upload Video",
                                        style: cTextStyleMedium,
                                      )
                                    : Text(videoName, style: cTextStyleMedium),
                                onPress: () {
                                  _videoFromGallery();
                                },
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.01,
                              ),
                              Container(
                                height: Styles.height(context) * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: CupertinoPicker(
                                  magnification: 2,
                                  children: [
                                    for (int i = 0; i < genderList.length; i++)
                                      Text(
                                        genderList[i],
                                        style: cTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                  ],
                                  itemExtent: 20,
                                  onSelectedItemChanged: (int value) {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      _gender = genderList[value];
                                      print(_gender);
                                    });
                                  },
                                ),
                              ),
                              CustomTextField(
                                obscureText: false,
                                labelText: 'Description',
                                hinText: 'Add Something',
                                onChanged: (String getDesc) {
                                  desc = getDesc;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.01,
                              ),
                              RoundRectButtonChild(
                                height: 50,
                                backgroundColor: CustomColor.primaryColor,
                                child: Text(
                                  "Save",
                                  style: cTextStyleMedium,
                                ),
                                onPress: () {
                                  if (_gender != null && videoName != null) {
                                    Navigator.pop(context);
                                    saveVideo();
                                  } else {
                                    Toaster.showToast(
                                        "Please add complete details",
                                        ToastGravity.TOP);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ContentCards(
                    title: 'Add Image',
                    imgPath: "assets/images/add_photo_img.png",
                    onpress: () {
                      bottomModalSheet(
                        height: Styles.height(context) * 0.5,
                        context: context,
                        kChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundRectButtonChild(
                                height: 50,
                                backgroundColor: Colors.grey[500],
                                child: imageName == null
                                    ? Text(
                                        "Upload Image",
                                        style: cTextStyleMedium,
                                      )
                                    : Text(imageName, style: cTextStyleMedium),
                                onPress: () {
                                  _imgFromGallery();
                                },
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.01,
                              ),
                              Container(
                                height: Styles.height(context) * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: CupertinoPicker(
                                  magnification: 2,
                                  children: [
                                    for (int i = 0; i < genderList.length; i++)
                                      Text(
                                        genderList[i],
                                        style: cTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                  ],
                                  itemExtent: 20,
                                  onSelectedItemChanged: (int value) {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      _gender = genderList[value];
                                      print(_gender);
                                    });
                                  },
                                ),
                              ),
                              CustomTextField(
                                obscureText: false,
                                labelText: 'Description',
                                hinText: 'Add Something',
                                onChanged: (String getDesc) {
                                  desc = getDesc;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.01,
                              ),
                              RoundRectButtonChild(
                                height: 50,
                                backgroundColor: CustomColor.primaryColor,
                                child: Text(
                                  "Save",
                                  style: cTextStyleMedium,
                                ),
                                onPress: () {
                                  if (_gender != null && imageName != null) {
                                    Navigator.pop(context);
                                    saveFiles();
                                  } else {
                                    Toaster.showToast(
                                        "Please add complete details",
                                        ToastGravity.TOP);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imgFromGallery() async {
    final fileresult =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (fileresult != null) {
      File image = File(fileresult.path);
      String filename = "imagePost";
      setState(() {
        getImage = image;
        imageName = filename;
      });
    } else {
      print("User canceled the picker");
    }
  }

  _videoFromGallery() async {
    final fileresult =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (fileresult != null) {
      File video = File(fileresult.path);
      String filename = "videoPost";
      setState(() {
        getVideo = video;
        videoName = filename;
      });
    } else {
      print("User canceled the picker");
    }
  }

  Future<void> saveVideo() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      TaskSnapshot uploadVideo = await FirebaseStorage.instance
          .ref()
          .child("$videoName")
          .putFile(getVideo);

      videoUrl = await uploadVideo.ref.getDownloadURL();
      _currentPosition = await location.getLocation();
      addPostToTimeline(videoUrl, "video");
    } on Exception catch (e) {
      Toaster.showToast("Error", ToastGravity.TOP);
    }
  }

  Future<void> saveFiles() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      TaskSnapshot uploadImage = await FirebaseStorage.instance
          .ref()
          .child("$imageName")
          .putFile(getImage);

      imageUrl = await uploadImage.ref.getDownloadURL();
      _currentPosition = await location.getLocation();
      addPostToTimeline(imageUrl, "image");
    } on Exception catch (e) {
      Toaster.showToast("Error", ToastGravity.TOP);
    }
  }

  Future<void> addPostToTimeline(String url, String format) async {
    FocusScope.of(context).unfocus();
    var fileRef = FireCollection.timelineCollectionDoc();
    await fileRef.set({
      'type': _gender,
      'url': url == null ? 'N/A' : url,
      'userId': FireCollection().userId,
      'timestamp': FieldValue.serverTimestamp(),
      'lat': _currentPosition.latitude,
      'lng': _currentPosition.longitude,
      'format': format,
      'desc': desc,
      'userName': '$fName $lName',
      'userImg': userImg,
    }).then((value) {
      setState(() {
        isLoading = false;
        imageName = null;
        videoName = null;
      });
      print("Saved Successfully");
      Toaster.showToast("Saved Successfully", ToastGravity.TOP);
    }).catchError((e) => print("Error Saving"));
  }
}

class ContentCards extends StatelessWidget {
  Function onpress;
  String imgPath, title;

  ContentCards({this.onpress, this.imgPath, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[100],
        elevation: 5.0,
        child: MaterialButton(
            elevation: 5.0,
            onPressed: onpress,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imgPath,
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    title,
                    style: cTextStyleLarge,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
