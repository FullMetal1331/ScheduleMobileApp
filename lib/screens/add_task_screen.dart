import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_app/models/task_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class AddTaskScreen extends StatelessWidget {
  static String newTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Add Task',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w400,
                color: Color(0xffFFC107),
              ),
            ),
            TextField(
              onChanged: (value) {
                newTask = value;
              },
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffFF9800),
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                if (newTask != null) {
                  var docID = '';
                  for (String s in newTask.split(' ')) {
                    docID += s;
                    print(s);
                  }
                  docID +=
                      (DateTime.now().millisecondsSinceEpoch / 1000).toString();

                  Provider.of<TaskData>(context, listen: false)
                      .addTask(newTask, docID);

                  _firestore.collection('tasks').doc(docID).set({
                    'task': newTask,
                    'sender': Provider.of<TaskData>(context, listen: false)
                        .getUser()
                        .email,
                    'timeStamp': DateTime.now().millisecondsSinceEpoch,
                    'isDone': false,
                  });

                  // Provider.of<TaskData>(context, listen: false).addToSS(docID);

                  Navigator.pop(context);
                }
              },
              height: 60.0,
              color: Color(0xffFFC107),
              child: Center(
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
