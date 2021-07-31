import 'package:animated_text_kit/animated_text_kit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: CustomColor.primaryGradient
      ),
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
                          padding: EdgeInsets.only(top: 35, left: 10, right: 10),
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
                tag:"tagImg",
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset("assets/images/branch_leaves.png",height: Styles.height(context) * 0.25,),
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
                                      : Text(
                                          'Sign In',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                  backgroundColor: CustomColor.primaryColor,
                                  height: 40,
                                  onPress: () {
                                    if (checkEmail(_email)) {
                                      if (_email != null && _pass != null) {
                                        userLogin();
                                      }
                                    } else {
                                      Toaster.showToast(
                                          "Invalid email address", ToastGravity.TOP);
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
    );
  }

  Future<void> userLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _pass,
      );
      if (user != null) {
        Navigator.pushNamed(context, BottomBarPage.id);
      }
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Toaster.showToast('No user found for that email.', ToastGravity.TOP);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Toaster.showToast(
            'Wrong password provided for the user.', ToastGravity.TOP);
      }
    }
  }

  bool checkEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height
        - 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height,
        size.width, size.height-30);
    path.lineTo(size.width, 0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}