import 'package:schedule_app/components/button_styles.dart';
import 'package:schedule_app/screens/time_table_days_screen.dart';
import 'package:schedule_app/screens/todo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flash_chat/components/message_bubble.dart';
import 'package:schedule_app/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'user_settings_screen.dart';

User loggedInUser;
final FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();

void showNotification(id, v) async {
  var android = AndroidNotificationDetails(
      'channel id$id', 'channel NAME$id', 'CHANNEL DESCRIPTION$id',
      priority: Priority.high, importance: Importance.max, autoCancel: false);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(0, 'Schedule App', '$v', platform, payload: 'VIS \n $v');
}

Future<void> initializeFLP() async {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flp.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
}

class ProfileScreen extends StatefulWidget {
  static const id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  bool _enabled = true, _isGreeted = false;
  int _status = 0;
  List<DateTime> _events = [];

  void getCurrentUser() {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        Provider.of<TaskData>(context, listen: false).updateUser(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  void getUserData() async {
    try {
      Provider.of<TaskData>(context, listen: false).getUserData();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    getUserData();

    initializeFLP();
    initPlatformState();
  }

  void reCalculateInflictionPoint() {
    try {
      Provider.of<TaskData>(context, listen: false)
          .reCalculateInflictionPoint();
    } catch (e) {
      print(e);
    }
  }

  @override
  void deactivate() {
    super.deactivate();

    Provider.of<TaskData>(context, listen: false).resetUser();
    reCalculateInflictionPoint();
  }

  //background_fetch start

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");

      var dayOfTheWeek, hourOfTheDay;

      hourOfTheDay = DateTime.now().hour - 8;

      switch (DateTime.now().weekday) {
        case (1):
          dayOfTheWeek = 'monday';
          break;
        case (2):
          dayOfTheWeek = 'tuesday';
          break;
        case (3):
          dayOfTheWeek = 'wednesday';
          break;
        case (4):
          dayOfTheWeek = 'thursday';
          break;
        case (5):
          dayOfTheWeek = 'friday';
          break;
        case (6):
          dayOfTheWeek = 'saturday';
          break;
        case (7):
          dayOfTheWeek = 'sunday';
          break;
      }

      if (!_isGreeted) {
        _isGreeted = true;

        showNotification(0, 'Hey there, ${_auth.currentUser.displayName}!');
      }

      await FirebaseFirestore.instance
          .collection('timeTable')
          .doc(_auth.currentUser.email)
          .get()
          .then((DocumentSnapshot snap) {
        print(hourOfTheDay);
        print(dayOfTheWeek);

        if (hourOfTheDay >= 0 && hourOfTheDay <= 8) {
          var subject = snap.data()['timeTable'][dayOfTheWeek][hourOfTheDay];
          if (subject != '') {
            showNotification(1, 'Upcoming $subject');
          } else {
            print('Free Period');
            // showNotification(1, 'Free Period');
          }
        } else {
          print('No notification will be shown');
        }
      });

      setState(() {
        _events.insert(0, new DateTime.now());
        print(DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  //background_fetch end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF9800),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Schedule App',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 60.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lalezar',
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            FlatButton(
              child: CircleAvatar(
                radius: 100.0,
                backgroundColor: Color(0xffffb445),
                child: Container(
                  padding: EdgeInsets.only(bottom: 40.0, right: 10.0),
                  child: Image(
                    image: NetworkImage((Provider.of<TaskData>(context)
                            .getUser()
                            .photoURL) ??
                        'https://robohash.org/${kGetRandomString(7)}?size=160x160'),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, UserSettingsScreen.id);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Center(
                child: TextLiquidFill(
                  boxHeight: 100.0,
                  boxWidth: double.infinity,
                  boxBackgroundColor: Color(0xffFF9800),
                  text:
                      (Provider.of<TaskData>(context).getUser().displayName) ??
                          'Unnamed',
                  waveColor: Colors.white,
                  waveDuration: Duration(seconds: 1),
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    color: Color(0xffFF9800),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: RoundedButtonStyle1(
                colour: Color(0xffF57C00),
                text: 'Time-Table',
                func1: () async {
                  Navigator.pushNamed(context, TimeTableDays.id);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: RoundedButtonStyle1(
                colour: Color(0xffFFC107),
                text: 'To-Do List',
                func1: () async {
                  Provider.of<TaskData>(context, listen: false)
                      .updateTaskList();
                  Navigator.pushNamed(context, ToDoScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
