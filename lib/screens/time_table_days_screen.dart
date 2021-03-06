import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_app/models/task_data.dart';
import 'package:schedule_app/widgets/time_table_list.dart';

var timeTableData;

class TimeTableDays extends StatefulWidget {
  static const id = 'time_table_days_screen';
  @override
  _TimeTableDaysState createState() => _TimeTableDaysState();
}

class _TimeTableDaysState extends State<TimeTableDays> {
  @override
  final pageController = PageController(
    initialPage: 0,
  );

  void getTimeTableData() {
    timeTableData =
        Provider.of<TaskData>(context, listen: false).getTimeTable();
    TimeTableList.timeTableData = timeTableData;
  }

  void updateTimeTableData() {
    Provider.of<TaskData>(context, listen: false)
        .updateTimeTable(TimeTableList.timeTableData);
  }

  void initState() {
    super.initState();

    getTimeTableData();
  }

  @override
  void deactivate() {
    super.deactivate();

    updateTimeTableData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF9100),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 60.0,
              bottom: 30.0,
              left: 30.0,
              right: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30.0,
                    color: Color(0xffFF9800),
                  ),
                  backgroundColor: Colors.white,
                  radius: 30.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Time Table',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Plan your days',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 40.0,
                top: 20.0,
              ),
              child: PageView(
                controller: pageController,
                children: <Widget>[
                  TimeTableList(
                    dayIndex: 0,
                    name: 'Monday',
                  ),
                  TimeTableList(
                    dayIndex: 1,
                    name: 'Tuesday',
                  ),
                  TimeTableList(
                    dayIndex: 2,
                    name: 'Wednesday',
                  ),
                  TimeTableList(
                    dayIndex: 3,
                    name: 'Thursday',
                  ),
                  TimeTableList(
                    dayIndex: 4,
                    name: 'Friday',
                  ),
                  TimeTableList(
                    dayIndex: 5,
                    name: 'Saturday',
                  ),
                  TimeTableList(
                    dayIndex: 6,
                    name: 'Sunday',
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
