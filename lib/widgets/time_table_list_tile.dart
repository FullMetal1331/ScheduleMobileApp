import 'package:flutter/material.dart';

class TimeTableListTile extends StatelessWidget {
  final String initValue, labelText;
  final Function onChanged;

  TimeTableListTile({this.initValue, this.labelText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color(0xffffb445),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
