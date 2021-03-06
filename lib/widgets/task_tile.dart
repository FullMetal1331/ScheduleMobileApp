import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_app/models/task_data.dart';

class TaskTile extends StatelessWidget {
  @override
  final String taskName, taskID;
  final bool isChecked;
  final int taskIndex;
  final bool isImportant;

  TaskTile(
      {this.isImportant,
      this.taskName,
      this.isChecked,
      this.taskIndex,
      this.taskID});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskName,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
          color: (isImportant) ? Colors.red : Colors.black,
          fontSize: (isImportant) ? 30.0 : 15.0,
        ),
      ),
      onLongPress: () {
        Provider.of<TaskData>(context, listen: false)
            .delTask(taskIndex, taskID);
      },
      trailing: Checkbox(
        activeColor: Color(0xffFFC107),
        value: isChecked,
        onChanged: (newValue) {
          Provider.of<TaskData>(context, listen: false)
              .doTask(taskIndex, taskID, newValue);
        },
      ),
    );
  }
}
