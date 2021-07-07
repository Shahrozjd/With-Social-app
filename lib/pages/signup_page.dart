import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "signUp_page";
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                      FadeAnimatedText('Hi!',textStyle: GoogleFonts.mPlusRounded1c(fontSize: 40,color: Colors.white)),
                      FadeAnimatedText('Welcome Back',textStyle: GoogleFonts.mPlusRounded1c(fontSize: 40,color: Colors.white)),
                    ],
                    repeatForever: true,
                    pause: Duration(milliseconds: 200),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Hero(
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
                  height: 500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<void> userSignUp() async {
  //   if (_cnfmPass == _pass) {
  //     FocusScope.of(context).unfocus();
  //     setState(() {
  //       isLoading = true;
  //     });
  //     try {
  //       final newuser =
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: _email,
  //         password: _pass,
  //       );
  //       if (newuser != null) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OnBoardingInfo(true),
  //           ),
  //         );
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       if (e.code == 'weak-password') {
  //         Toaster.showToast('Weak Password', ToastGravity.TOP);
  //       } else if (e.code == 'email-already-in-use') {
  //         print('The account already exists for that email.');
  //         Toaster.showToast(
  //             'The account already exists for that email.', ToastGravity.TOP);
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     Toaster.showToast('Password not matched', ToastGravity.TOP);
  //   }
  // }

  bool checkEmail(String email) {
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

}
