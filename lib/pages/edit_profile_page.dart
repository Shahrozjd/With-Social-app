import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:with_app/components/CustomTextField.dart';
import 'package:with_app/components/round_rect_button.dart';
import 'package:with_app/components/round_rect_button_child.dart';
import 'package:with_app/components/toaster.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/styles/styles.dart';

class EditProfilePage extends StatefulWidget {
  static const String id = "EditProfilePage";

  const EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();
  String _gender, _email, _image;
  bool isLoading = false;
  String imageName, imageUrl;
  File getImage;
  List<String> genderList = [
    'male',
    'female',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    getFirestoreData();
  }

  Future<void> getFirestoreData() async {
    await FireCollection.userDoc()
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          fNameController.text = snapshot['firstName'].toString();
          lNameController.text = snapshot['lastName'].toString();
          aboutController.text = snapshot['about'].toString();
          imageUrl = snapshot['image'].toString();
          _email = snapshot['email'].toString();
          _image = snapshot['image'].toString();
          _gender = snapshot['gender'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Profile Edit",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'imgTag',
                      child: AnimatedContainer(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: _image != null
                                  ? NetworkImage(_image)
                                  : AssetImage(""),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              )
                            ]),
                        duration: Duration(milliseconds: 1000),
                      ),
                    ),
                    SizedBox(
                      height: Styles.height(context) * 0.02,
                    ),
                    Text(
                      _email != null ? _email : "n/a",
                      style: cTextStyleMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: Styles.height(context) * 0.02,
                ),
                RoundRectButtonChild(
                  child: imageName != null
                      ? Text(
                          imageName,
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          'Edit Image',
                          style: TextStyle(color: Colors.black),
                        ),
                  backgroundColor: Colors.grey[200],
                  height: 40,
                  width: 150,
                  onPress: () {
                    _imgFromGallery();
                  },
                ),
                CustomTextField(
                  obscureText: false,
                  labelText: 'First Name',
                  controller: fNameController,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomTextField(
                  obscureText: false,
                  labelText: 'Last Name',
                  controller: lNameController,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomTextField(
                  obscureText: false,
                  labelText: 'About',
                  controller: aboutController,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: Styles.height(context) * 0.01,
                ),
                Container(
                  height: Styles.height(context) * 0.08,
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
                SizedBox(
                  height: Styles.height(context) * 0.01,
                ),
                RoundRectButton(
                  text: "Save",
                  height: 40,
                  onPress: () {
                      saveData();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imgFromGallery() async {
    FilePickerResult fileresult =
        await FilePicker.platform.pickFiles(type: FileType.image);
    File image = File(fileresult.files.first.path);
    String filename = fileresult.files.first.name;
    // saveFile(fileforfirebase, filename);
    //
    setState(() {
      getImage = image;
      imageName = filename;
    });
    saveFiles();
  }

  Future<void> saveFiles() async {
    FocusScope.of(context).unfocus();
    setState(() {

      isLoading = true;
      Toaster.showToast("Uploading", ToastGravity.TOP);
    });
    try {
      TaskSnapshot uploadImage = await FirebaseStorage.instance
          .ref()
          .child("$imageName")
          .putFile(getImage);

      imageUrl = await uploadImage.ref.getDownloadURL();
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      Toaster.showToast("Error", ToastGravity.TOP);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });
    await FireCollection.userDoc().update({
      'firstName': fNameController.text,
      'lastName': lNameController.text,
      'about':aboutController.text,
      'image': imageUrl,
      'gender': _gender,
    }).then((value) {
      Toaster.showToast("Data Saved", ToastGravity.TOP);
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      print('Error occurred while saving $e');
      isLoading = false;
    });
  }
}
