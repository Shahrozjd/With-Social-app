import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:with_app/components/CustomTextField.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button.dart';
import 'package:with_app/components/round_rect_button_child.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/components/toaster.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/bottom_bar_page.dart';
import 'package:with_app/pages/login_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "signUp_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _fName, _lName, _email, _pass, _cfmPass, _gender;
  bool isLoading = false;
  List<String> genderList = [
    'male',
    'female',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _gender = genderList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomColor.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Stack(
            children: [
              Container(
                height: Styles.height(context),
                width: Styles.width(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'tagClip',
                      child: ClipPath(
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 35, left: 10, right: 10),
                          height: Styles.height(context) * 0.18,
                          color: Colors.black.withOpacity(0.2),
                          child: SizedBox(
                            width: 250.0,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  FadeAnimatedText('Hi!',
                                      textStyle: GoogleFonts.mPlusRounded1c(
                                          fontSize: 40, color: Colors.white)),
                                  FadeAnimatedText('Welcome Back',
                                      textStyle: GoogleFonts.mPlusRounded1c(
                                          fontSize: 40, color: Colors.white)),
                                ],
                                repeatForever: true,
                                pause: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                        ),
                        clipper: CustomClipPath(),
                      ),
                    ),
                  ],
                ),
              ),
              Hero(
                tag: "tagImg",
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      "assets/images/branch_leaves.png",
                      height: Styles.height(context) * 0.15,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      height: Styles.height(context) * 0.1,
                    ),
                    Hero(
                      tag: "tagCont",
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 5))
                              ]),
                          margin: EdgeInsets.all(15),
                          child: Wrap(
                            children: [
                              Text(
                                "Sign Up",
                                style: cTextStyleMediumBoldAccent,
                              ),
                              CustomTextField(
                                obscureText: false,
                                hinText: "Enter your First Name",
                                labelText: "First Name",
                                inputType: TextInputType.emailAddress,
                                onChanged: (String getFName) {
                                  _fName = getFName;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.02,
                              ),
                              CustomTextField(
                                obscureText: false,
                                hinText: "Enter your Last Name",
                                labelText: "Last Name",
                                inputType: TextInputType.emailAddress,
                                onChanged: (String getLName) {
                                  _lName = getLName;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.02,
                              ),
                              CustomTextField(
                                obscureText: false,
                                hinText: "Enter your email",
                                labelText: "Email",
                                inputType: TextInputType.emailAddress,
                                onChanged: (String getEmail) {
                                  _email = getEmail;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.02,
                              ),
                              CustomTextField(
                                obscureText: true,
                                hinText: "Enter your Password",
                                labelText: "Password",
                                inputType: TextInputType.emailAddress,
                                onChanged: (String getPass) {
                                  _pass = getPass;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.02,
                              ),
                              CustomTextField(
                                obscureText: true,
                                hinText: "Enter your Password Again",
                                labelText: "Confirm Password",
                                inputType: TextInputType.emailAddress,
                                onChanged: (String getCPass) {
                                  _cfmPass = getCPass;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.1,
                              ),
                              Container(
                                height: Styles.height(context) * 0.08,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
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
                                height: Styles.height(context) * 0.1,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: RoundRectButtonChild(
                                  child: isLoading
                                      ? CustomLoading()
                                      : Text(
                                          'Sign Up',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                  backgroundColor: CustomColor.primaryColor,
                                  height: 40,
                                  onPress: () {
                                    if (checkEmail(_email)) {
                                      if (_lName != null &&
                                          _fName != null &&
                                          _email != null &&
                                          _pass != null &&
                                          _cfmPass != null) {
                                        if (_pass == _cfmPass) {
                                          userSignUp();
                                        } else {
                                          Toaster.showToast(
                                              "Password did not match",
                                              ToastGravity.TOP);
                                        }
                                      } else {
                                        Toaster.showToast(
                                            "Please fill all fields",
                                            ToastGravity.TOP);
                                      }
                                    } else {
                                      Toaster.showToast("Invalid email address",
                                          ToastGravity.TOP);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: Styles.height(context) * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Styles.height(context) * 0.01,
                    ),
                    RoundRectButtonCustom(
                      text: 'Back',
                      height: 50,
                      backgroundColor: Colors.white,
                      foregroundColor: CustomColor.primaryColor,
                      onPress: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> userSignUp() async {
    if (_cfmPass == _pass) {
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      try {
        final newuser =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _pass,
        );
        try {
          await newuser.user.sendEmailVerification();
          Toaster.showToast(
              'Verification email has been sent', ToastGravity.TOP);
        } catch (e) {
          print(
              "An error occured while trying to send email        verification");
          print(e.message);
        }
        if (newuser != null) {
          setState(() {
            isLoading = false;
          });
          addUserData();
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });

        if (e.code == 'weak-password') {
          Toaster.showToast('Weak Password', ToastGravity.TOP);
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          Toaster.showToast(
              'The account already exists for that email.', ToastGravity.TOP);
        }
      } catch (e) {
        print(e);
      }
    } else {
      Toaster.showToast('Password not matched', ToastGravity.TOP);
    }
  }

  Future<void> addUserData() async {
    await FireCollection().userDoc().set({
      'email': _email,
      'firstName': _fName,
      'lastName': _lName,
      'gender': _gender,
      'image': 'n/a',
      'about': 'n/a'
    }).then((value) {
      print('user data added successfully');
      Navigator.pushReplacementNamed(context, LoginPage.id);
    }).catchError((e) => print('error saving user data'));
  }

  bool checkEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }
}
