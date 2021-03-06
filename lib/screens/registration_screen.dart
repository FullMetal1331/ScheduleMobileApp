import 'package:schedule_app/constants.dart';
// import 'package:flash_chat/screens/chat_screen.dart';
import 'package:schedule_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/components/button_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:schedule_app/models/task_data.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email, password;
  bool isSpinning = false;
  final _auth = FirebaseAuth.instance;

  void createNewUser(String email) async {
    await Provider.of<TaskData>(context, listen: false).createNewUser(email);
  }

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
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Email', fillColor: Colors.white),
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
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Password', fillColor: Colors.white),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButtonStyle1(
                text: 'Register',
                colour: Color(0xffFFC107),
                func1: () async {
                  setState(() {
                    isSpinning = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  print(email);
                  print(password);
                  try {
                    var user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      createNewUser(email);
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
