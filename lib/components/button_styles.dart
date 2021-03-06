import 'package:flutter/material.dart';

class RoundedButtonStyle1 extends StatelessWidget {
  final Color colour;
  final String text;
  final Function func1;

  RoundedButtonStyle1({this.colour, this.text, this.func1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 70.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: func1,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
      ),
    );
  }
}
