import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:with_app/components/CustomTextField.dart';
import 'package:with_app/components/round_rect_button.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/pages/signup_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class LoginPage extends StatefulWidget {
  static const String id = "login_page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email,_pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: Styles.height(context),
              width: Styles.width(context),
              decoration: BoxDecoration(
                gradient: CustomColor.primaryGradient,
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
                      FadeAnimatedText('Welcome',textStyle: GoogleFonts.mPlusRounded1c(fontSize: 40,color: Colors.white)),
                      FadeAnimatedText('TO',textStyle: GoogleFonts.mPlusRounded1c(fontSize: 40,color: Colors.white)),
                      FadeAnimatedText('With',textStyle: GoogleFonts.mPlusRounded1c(fontSize: 50,color: Colors.white)),
                    ],
                    repeatForever: true,
                    pause: Duration(milliseconds: 200),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Hero(
                    tag: 'tagCont',
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
                          Text("Login",style: cTextStyleMediumBoldAccent,),
                          CustomTextField(
                            obscureText: false,
                            hinText: "Enter your email",
                            labelText: "Email",
                            inputType: TextInputType.emailAddress,
                            onChanged: (String getEmail){

                            },
                            onEditingComplete: (){
                              FocusScope.of(context).nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: Styles.height(context) * 0.02,
                          ),
                          CustomTextField(
                            obscureText: false,
                            hinText: "Enter your Password",
                            labelText: "Password",
                            inputType: TextInputType.emailAddress,
                            onChanged: (String getPass){

                            },
                            onEditingComplete: (){
                              FocusScope.of(context).nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: Styles.height(context) * 0.1,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: RoundRectButton(
                              text: 'Sign In',
                              height: 40,
                              onPress: (){

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
                  SizedBox(
                    height: Styles.height(context) * 0.01,
                  ),
                  RoundRectButtonCustom(
                    text: 'Sign Up',
                    height: 50,
                    backgroundColor: Colors.white,
                    foregroundColor: CustomColor.primaryColor,
                    onPress: (){
                      Navigator.pushNamed(context, SignUpPage.id);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> userLogin() async {
  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _email,
  //       password: _pass,
  //     );
  //     if (user != null) {
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeBottomBar()));
  //     }
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //       Toaster.showToast('No user found for that email.', ToastGravity.TOP);
  //
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //       Toaster.showToast('Wrong password provided for the user.', ToastGravity.TOP);
  //     }
  //   }
  // }


  bool checkEmail(String email) {
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }
}
