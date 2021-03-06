import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:schedule_app/components/button_styles.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:background_fetch/background_fetch.dart';
// import 'package:flash_chat/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flash_chat/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });

    animation = ColorTween(begin: Colors.blueGrey, end: Color(0xffFF9800))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: CircleAvatar(
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 35.0,
                    ),
                    radius: 25.0,
                    backgroundColor: Color(0xffffb445),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                TypewriterAnimatedTextKit(
                  text: ['Schedule App'],
                  textStyle: TextStyle(
                    fontFamily: 'Lalezar',
                    fontSize: 48.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  speed: Duration(milliseconds: 200),
                  repeatForever: false,
                  totalRepeatCount: 1,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButtonStyle1(
                text: 'Log In',
                colour: Color(0xffF57C00),
                func1: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            RoundedButtonStyle1(
                text: 'Register',
                colour: Color(0xffFFC107),
                func1: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
