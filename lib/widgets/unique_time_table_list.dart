import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_app/models/task_data.dart';

class UniqueTimeTableList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          key: UniqueKey(),
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 5.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskData.uniqueTimeTableEntries[index],
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Divider(
                    color: Colors.orange,
                    thickness: 0.5,
                  ),
                ],
              ),
            );
          },
          itemCount: taskData.uniqueTimeTableEntries.length,
        );
      },
    );
  }
}
