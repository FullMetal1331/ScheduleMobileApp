import 'package:flutter/material.dart';
import 'package:schedule_app/widgets/task_tile.dart';
import 'package:schedule_app/models/task_data.dart';
import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flash_chat/models/task.dart';

// final _firestore = FirebaseFirestore.instance;

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return TaskTile(
              taskName: taskData.tasks[index].name,
              isChecked: taskData.tasks[index].isDone,
              taskIndex: index,
              isImportant: taskData.tasks[index].isImportant,
              taskID: taskData.tasks[index].taskID,
            );
          },
          itemCount: taskData.tasks.length,
        );
      },
    );
  }
}
