import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_app/constants.dart';
// import 'package:flash_chat/screens/chat_screen.dart';
import 'package:schedule_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/components/button_styles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  bool isSpinning = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF9800),
      body: ModalProgressHUD(
        inAsyncCall: isSpinning,
        color: Color(0xffffb445),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: CircleAvatar(
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 200.0,
                    ),
                    radius: 150.0,
                    backgroundColor: Color(0xffffb445),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                textAlign: TextAlign.center,
                obscureText: true,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButtonStyle1(
                text: 'Log In',
                colour: Color(0xffF57C00),
                func1: () async {
                  setState(() {
                    isSpinning = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  try {
                    var user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.pushNamed(context, ProfileScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    isSpinning = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
