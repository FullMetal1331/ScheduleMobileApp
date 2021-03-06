import 'package:schedule_app/widgets/unique_time_table_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/models/task_data.dart';
import 'package:schedule_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_app/components/button_styles.dart';

class UserSettingsScreen extends StatefulWidget {
  static const id = 'user_settings_screen';
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  User user;
  String name;

  @override
  void initState() {
    super.initState();

    user = Provider.of<TaskData>(context, listen: false).getUser();
    name = user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF9800),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 109.0,
          ),
          CircleAvatar(
            radius: 100.0,
            backgroundColor: Color(0xffffb445),
            child: Container(
              padding: EdgeInsets.only(bottom: 40.0, right: 10.0),
              child: Image(
                  image: NetworkImage((Provider.of<TaskData>(context)
                          .getUser()
                          .photoURL) ??
                      'https://robohash.org/${kGetRandomString(7)}?size=140x140')),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter New UserName',
                  hintStyle: TextStyle(color: Colors.grey)),
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: RoundedButtonStyle1(
              colour: Color(0xffF57C00),
              text: 'Save',
              func1: () async {
                if (name != user.displayName && name != null && name != '') {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Provider.of<TaskData>(context, listen: false)
                        .updateUserName(name);
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 20.0,
              ),
              Text(
                'Subjects',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
              child: Container(
                child: UniqueTimeTableList(),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
