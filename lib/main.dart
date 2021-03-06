// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
import 'screens/profile_screen.dart';
import 'screens/time_table_days_screen.dart';
import 'screens/todo_screen.dart';
import 'screens/user_settings_screen.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:provider/provider.dart';
import 'screens/todo_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/task_data.dart';
import 'screens/time_table_days_screen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:page_transition/page_transition.dart';
// import 'constants.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

//variables start

//variables end

//functions Start
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

//function End

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(FlashChat());

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case WelcomeScreen.id:
              {
                return PageTransition(
                  child: WelcomeScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                  reverseDuration: Duration(milliseconds: 1005),
                  duration: Duration(milliseconds: 1005),
                );
              }
              break;
            case LoginScreen.id:
              {
                return PageTransition(
                  child: LoginScreen(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                  reverseDuration: Duration(milliseconds: 1005),
                  duration: Duration(milliseconds: 1005),
                );
              }
              break;
            case RegistrationScreen.id:
              {
                return PageTransition(
                  child: RegistrationScreen(),
                  type: PageTransitionType.rightToLeft,
                  settings: settings,
                  reverseDuration: Duration(milliseconds: 1005),
                  duration: Duration(milliseconds: 1005),
                );
              }
              break;
            case ProfileScreen.id:
              {
                return PageTransition(
                  child: ProfileScreen(),
                  type: PageTransitionType.size,
                  alignment: Alignment.topLeft,
                  settings: settings,
                  reverseDuration: Duration(milliseconds: 1005),
                  duration: Duration(milliseconds: 1005),
                );
              }
              break;
            case ToDoScreen.id:
              {
                return PageTransition(
                  child: ToDoScreen(),
                  type: PageTransitionType.leftToRightWithFade,
                  settings: settings,
                  reverseDuration: Duration(milliseconds: 1005),
                  duration: Duration(milliseconds: 1005),
                );
              }
              break;
            case TimeTableDays.id:
              {
                return PageTransition(
                  child: TimeTableDays(),
                  type: PageTransitionType.rightToLeftWithFade,
                  settings: settings,
                  reverseDuration: Duration(milliseconds: 1005),
                  duration: Duration(milliseconds: 1005),
                );
              }
              break;
            case UserSettingsScreen.id:
              {
                return PageTransition(
                  child: UserSettingsScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                  reverseDuration: Duration(milliseconds: 1005),
                  duration: Duration(milliseconds: 1005),
                );
              }
              break;

            default:
              return null;
          }
        },
      ),
    );
  }
}
