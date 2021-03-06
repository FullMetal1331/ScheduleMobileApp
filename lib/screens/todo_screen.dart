import 'package:flutter/material.dart';
// import 'package:flash_chat/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flash_chat/components/message_bubble.dart';
import 'package:schedule_app/screens/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:schedule_app/models/task_data.dart';
import 'package:schedule_app/widgets/tasks_list.dart';

// final _firestore = FirebaseFirestore.instance;

class ToDoScreen extends StatefulWidget {
  static const id = 'todo_screen';
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    // print(loggedInUser.email);
    return Scaffold(
      backgroundColor: Color(0xffFFC107),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xffFFC107),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddTaskScreen(),
          );
        },
      ),
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
                    color: Color(0xffFFC107),
                  ),
                  backgroundColor: Colors.white,
                  radius: 30.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'To-Do List',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${Provider.of<TaskData>(context).tasks.length} Tasks',
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
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: TasksList(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
