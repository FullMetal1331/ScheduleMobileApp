import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/time_table_list_tile.dart';

class TimeTableList extends StatelessWidget {
  static List<List<String>> timeTableData;
  final String name;
  final int dayIndex;

  TimeTableList({this.dayIndex, this.name});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
              color: Color(0xffFF9800),
              fontSize: 20.0,
              fontWeight: FontWeight.w400),
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][0],
          labelText: "9:00-10:00",
          onChanged: (value) {
            timeTableData[dayIndex][0] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][1],
          labelText: "10:00-11:00",
          onChanged: (value) {
            timeTableData[dayIndex][1] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][2],
          labelText: "11:00-12:00",
          onChanged: (value) {
            timeTableData[dayIndex][2] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][3],
          labelText: "12:00-13:00",
          onChanged: (value) {
            timeTableData[dayIndex][3] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][4],
          labelText: "13:00-14:00",
          onChanged: (value) {
            timeTableData[dayIndex][4] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][5],
          labelText: "14:00-15:00",
          onChanged: (value) {
            timeTableData[dayIndex][5] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][6],
          labelText: "15:00-16:00",
          onChanged: (value) {
            timeTableData[dayIndex][6] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][7],
          labelText: "16:00-17:00",
          onChanged: (value) {
            timeTableData[dayIndex][7] = value;
          },
        ),
        TimeTableListTile(
          initValue: timeTableData[dayIndex][8],
          labelText: "17:00-18:00",
          onChanged: (value) {
            timeTableData[dayIndex][8] = value;
          },
        ),
      ],
    );
  }
}
