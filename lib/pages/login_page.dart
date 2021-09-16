import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:with_app/components/CustomTextField.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button.dart';
import 'package:with_app/components/round_rect_button_child.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/components/toaster.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/bottom_bar_page.dart';
import 'package:with_app/pages/home_page.dart';
import 'package:with_app/pages/signup_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class LoginPage extends StatefulWidget {
  static const String id = "login_page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _pass;
  bool isLoading = false;
  DateTime currentBackPressTime;

  User _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: '...');
      return Future.value(false);
    }
    return Future.value(false);
  }

  void getPermissions() async {
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
    getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomColor.primaryGradient),
      child: WillPopScope(
        onWillPop: onWillPop,
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
                            height: Styles.height(context) * 0.30,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                            ),
                            child: SizedBox(
                              width: 250.0,
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    FadeAnimatedText('Welcome',
                                        textStyle: GoogleFonts.mPlusRounded1c(
                                            fontSize: 40, color: Colors.white)),
                                    FadeAnimatedText('TO',
                                        textStyle: GoogleFonts.mPlusRounded1c(
                                            fontSize: 40, color: Colors.white)),
                                    FadeAnimatedText('With',
                                        textStyle: GoogleFonts.mPlusRounded1c(
                                            fontSize: 50, color: Colors.white)),
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
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top:100.0),
                //     child: Image.asset("images/auth_vector.png",height: Styles.height(context) * 0.15,fit: BoxFit.fill,),
                //   ),
                // ),
                Hero(
                  tag: "tagImg",
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        "assets/images/branch_leaves.png",
                        height: Styles.height(context) * 0.25,
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
                                  "Login",
                                  style: cTextStyleMediumBoldAccent,
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
                                  height: Styles.height(context) * 0.1,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: RoundRectButtonChild(
                                    child: isLoading
                                        ? CustomLoading()
                                        : Center(
                                            child: Text(
                                              'Sign In',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                    backgroundColor: CustomColor.primaryColor,
                                    height: 40,
                                    onPress: () {
                                      if (checkEmail(_email)) {
                                        if (_email != null && _pass != null) {
                                          userLogin();
                                        } else {
                                          Toaster.showToast(
                                              'Please fill in complete details',
                                              ToastGravity.TOP);
                                        }
                                      } else {
                                        Toaster.showToast(
                                            "Invalid email address",
                                            ToastGravity.TOP);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: Styles.height(context) * 0.07,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    RoundRectButtonChild(
                                      child: Icon(FontAwesome.google),
                                      height: 40,
                                      backgroundColor: Color(0xFF5482EC),
                                      onPress: () {
                                        signInWithGoogle();
                                      },
                                    )
                                  ],
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
                        text: 'Sign Up',
                        height: 50,
                        backgroundColor: Colors.white,
                        foregroundColor: CustomColor.primaryColor,
                        onPress: () {
                          Navigator.pushNamed(context, SignUpPage.id);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    var user;

    try {
      user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _pass,
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Toaster.showToast('No user found for that email.', ToastGravity.TOP);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Toaster.showToast(
            'Wrong password provided for the user.', ToastGravity.BOTTOM);
      }
      setState(() {
        isLoading = false;
      });
    }

    if (user != null) {
      if (user.user.emailVerified) {
        Navigator.pushNamed(context, BottomBarPage.id);
      } else {
        Toaster.showToast("Please verify your email address", ToastGravity.TOP);
      }
    }
  }

  bool checkEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  // this function is used to authenticate user with google
  Future<void> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    print("ACCESS TOKEN : ${googleSignInAuthentication.accessToken}");
    print("ID TOKEN : ${googleSignInAuthentication.idToken}");

    //getting auth result from google and signing in with those credentials
    var authResult = await _auth.signInWithCredential(credential);
    _user = authResult.user;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = await _auth.currentUser;
    assert(_user.uid == currentUser.uid);

    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");
    print("User Email ${_user.uid}");

    String userEmail = _user.email;
    String uid = _user.uid;
    String userName = _user.displayName;
    var name = userName.split(" ");
    String firstName = name[0];
    String lastName = name[1];

    print(firstName + lastName);

    // if user exist take to form filling page for profile
    if (_user.uid != null) {
      setUpUser(firstName, lastName, userEmail, uid);
    }
  }

  Future<void> setUpUser(
      String firstName, String lastName, String email, String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((doc) async {
      if (doc.exists) {
        print("Already Registered");
        Navigator.pushNamed(context, BottomBarPage.id);
      } else {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'gender': 'n/a',
          'image': 'n/a',
          'about': 'n/a'
        }).then((value) {
          print('user data added successfully');
          Navigator.pushNamed(context, BottomBarPage.id);
        }).catchError((e) => print('error saving user data'));
      }
    });
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
