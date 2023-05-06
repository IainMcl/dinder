import 'package:dinder/src/auth/screens/sign_up.dart';
import 'package:dinder/src/shared/widgets/carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dinder/src/shared/widgets/button.dart';
import 'package:dinder/src/shared/widgets/textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';

class LoginBodyScreen extends StatefulWidget {
  const LoginBodyScreen({super.key});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen> {
  final Logger _logger = Logger();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  static const double pushUpBorderRadius = 30;
  static const String fontColor = "#8d8d8d";
  static const String highlightFontColor = "#44564a";
  Color primaryColor = HexColor("#89b2f5");
  Color secondaryColor = const Color(0xffffffff);

  void signUserIn() async {
    // Show spinner dialog
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      var ret = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
      _logger.i('User signed in: ${ret.user!.uid}');
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      switch (error.code) {
        case "user-not-found":
          showErrorMessage("No user found for that email");
          break;
        case "wrong-password":
        case "invalid-email":
          showErrorMessage("Wrong email or password");
          break;
        default:
          showErrorMessage("Something went wrong");
      }
      _logger.i('Sign-in failed: ${error.code}');
    } catch (error) {
      showErrorMessage("Something went wrong");
      _logger.w('Sign-in failed: $error');
    }
  }

  // void signUserIn() async {
  //   // Show spinner dialog
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       });
  //   try {
  //     var ret = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //     Navigator.pop(context);
  //   } on FirebaseAuthException catch (error) {
  //     Navigator.pop(context);
  //     switch (error.code) {
  //       case "user-not-found":
  //         showErrorMessage("No user found for that email");
  //         break;
  //       case "wrong-password":
  //       case "invalid-email":
  //         showErrorMessage("Wrong email or password");
  //         break;
  //       default:
  //         showErrorMessage("Something went wrong");
  //     }
  //   } catch (error) {
  //     showErrorMessage("Something went wrong");
  //   }
  // }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    const Carousel(),
                    Container(
                      height: 535,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(pushUpBorderRadius),
                          topRight: Radius.circular(pushUpBorderRadius),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Log in",
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: HexColor("#4f4f4f"),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: HexColor(fontColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomTextField(
                                    onChanged: (() {
                                      validateEmail(emailController.text);
                                    }),
                                    controller: emailController,
                                    hintText: "hello@email.com",
                                    obscureText: false,
                                    prefixIcon: const Icon(Icons.mail_outline),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Text(
                                      _errorMessage,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Password",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: HexColor(fontColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomTextField(
                                    controller: passwordController,
                                    hintText: "********",
                                    obscureText: true,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Button(
                                    onPressed: signUserIn,
                                    buttonText: 'Log in',
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  // sign in with google
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Or log in with",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: HexColor(fontColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: Icon(FontAwesomeIcons.google,
                                            color: HexColor(fontColor)),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Icon(FontAwesomeIcons.apple,
                                            color: HexColor(fontColor)),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Icon(FontAwesomeIcons.github,
                                            color: HexColor(fontColor)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Don't have an account?",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: HexColor(fontColor),
                                            )),
                                        TextButton(
                                          child: Text(
                                            "Sign up",
                                            style: GoogleFonts.poppins(
                                              decoration: TextDecoration.underline,
                                              fontSize: 14,
                                              color: HexColor(highlightFontColor),
                                            ),
                                          ),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      /* offset: const Offset(0, -253), */
                      offset: const Offset(200, -253),
                      child: const Text("Logo")
                      // Image.asset(
                      //   'assets/images/plants2.png',
                      //   scale: 1.5,
                      //   width: double.infinity,
                      // ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
