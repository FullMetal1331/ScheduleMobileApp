import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:ml_preprocessing/ml_preprocessing.dart';

class TaskData extends ChangeNotifier {
  List<Task> _taskData = [];
  List<List<String>> _timeTable = [
    ['m1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'm8', 'm9'],
    ['tu1', 'tu2', 'tu3', 'tu4', 'tu5', 'tu6', 'tu7', 'tu8', 'tu9'],
    ['w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8', 'w9'],
    ['th1', 'th2', 'th3', 'th4', 'th5', 'th6', 't7h', 'th8', 'th9'],
    ['f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9'],
    ['sa1', 'sa2', 'sa3', 'sa4', 'sa5', 'sa6', 'sa7,', 'sa8', 'sa9'],
    ['su1', 'su2', 'su3', 'su4', 'su5', 'su6', 'su7', 'su8', 'su9']
  ];
  List<String> _uniqueTimeTableEntries = [];

  static User _loggedInUser;
  static String _userInflictionDocumentID, _timeTableDataDocumentID;
  static int _inflictionPoint;
  static List<String> inflictionData = [];
  var _fireStore = FirebaseFirestore.instance;

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_taskData);
  }

  UnmodifiableListView<String> get uniqueTimeTableEntries {
    return UnmodifiableListView(_uniqueTimeTableEntries);
  }

  void addTask(String s, String id) {
    _taskData.add(Task(name: s, taskID: id));
    notifyListeners();
  }

  void doTask(int ind, String id, bool val) async {
    print(val);
    try {
      await _fireStore
          .collection('tasks')
          .doc(id)
          .update({'isDone': val}).then((value) {
        _taskData[ind].toggleIsDone();
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void updateInflictionPoint(bool wasDone, var timeTaken) async {
    String val = '${(wasDone) ? 1 : 0}@$timeTaken';

    try {
      await _fireStore
          .collection('infliction')
          .doc(_userInflictionDocumentID)
          .update({
        'wasDone@timeTaken': FieldValue.arrayUnion([val]),
      });
    } catch (e) {
      print(e);
    }
  }

  void delTask(int ind, String id) async {
    try {
      var toDelEntry;
      bool wasDone;
      var timeTaken;

      await _fireStore
          .collection('tasks')
          .doc(id)
          .get()
          .then((DocumentSnapshot snap) {
        timeTaken =
            DateTime.now().millisecondsSinceEpoch - snap.data()['timeStamp'];
        wasDone = snap.data()['isDone'];
      }).then((value) {
        _fireStore.collection('tasks').doc(id).delete().then((value) {
          _taskData.removeAt(ind);
          notifyListeners();
          updateInflictionPoint(wasDone, timeTaken);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void updateUser(User user) {
    _loggedInUser = user;
    _timeTableDataDocumentID = user.email;
    _userInflictionDocumentID = user.email;
    notifyListeners();
  }

  void updateUserName(String s) async {
    print(s);
    print(FirebaseAuth.instance.currentUser.email);
    await FirebaseAuth.instance.currentUser
        .updateProfile(
            displayName: s, photoURL: 'https://robohash.org/$s?size=160x160')
        .then((value) {
      updateUser(FirebaseAuth.instance.currentUser);
    });
  }

  User getUser() {
    User user = _loggedInUser;
    return user;
  }

  void resetUser() {
    _taskData.clear();
    _timeTable = [
      ['', '', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '', '']
    ];
    _uniqueTimeTableEntries.clear();
  }

  List<List<String>> getTimeTable() {
    return _timeTable;
  }

  void getInflictionPoint() async {
    await _fireStore
        .collection('infliction')
        .where('sender', isEqualTo: _loggedInUser.email)
        .get()
        .then((QuerySnapshot snap) {
      _inflictionPoint = snap.docs[0].data()['inflictionPoint'];
      _userInflictionDocumentID = snap.docs[0].reference.id;

      if (_inflictionPoint == null ||
          _inflictionPoint == 0 ||
          _inflictionPoint < 172800000) _inflictionPoint = 172800000;

      for (String s in snap.docs[0].data()['wasDone@timeTaken']) {
        inflictionData.add(s);
      }
    });
  }

  Future<void> getUserData() async {
    await _fireStore
        .collection('timeTable')
        .doc(_loggedInUser.email)
        .get()
        .then((DocumentSnapshot snap) {
      if (snap != null) {
        print(
            'getUserData ${snap.data()['timeTable']['monday']}, ${_timeTable[0]}');
        try {
          for (int c1 = 0; c1 < 9; c1++) {
            _timeTable[0][c1] = snap.data()['timeTable']['monday'][c1];
            _timeTable[1][c1] = snap.data()['timeTable']['tuesday'][c1];
            _timeTable[2][c1] = snap.data()['timeTable']['wednesday'][c1];
            _timeTable[3][c1] = snap.data()['timeTable']['thursday'][c1];
            _timeTable[4][c1] = snap.data()['timeTable']['friday'][c1];
            _timeTable[5][c1] = snap.data()['timeTable']['saturday'][c1];
            _timeTable[6][c1] = snap.data()['timeTable']['sunday'][c1];
          }
        } catch (e) {
          print("timetable data prob $e");
        }
      } else {
        _timeTable = [
          ['', '', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '', '']
        ];
      }
    });

    //To-Do List
    _taskData.clear();

    await _fireStore
        .collection('tasks')
        .where('sender', isEqualTo: _loggedInUser.email)
        .get()
        .then((QuerySnapshot snap) {
      print(snap.docs.length);

      getInflictionPoint();

      _taskData.clear();
      for (var entries in snap.docs) {
        int tT =
            DateTime.now().millisecondsSinceEpoch - entries.data()['timeStamp'];

        _taskData.add(
          Task(
            name: entries.data()['task'],
            taskID: entries.reference.id,
            isDone: entries.data()['isDone'],
            timeTaken: (tT),
          ),
        );
      }
      notifyListeners();
    });
  }

  void makeUniqueTimeTableList() {
    if (_uniqueTimeTableEntries.isNotEmpty) {
      _uniqueTimeTableEntries.clear();
    }

    for (int c1 = 0; c1 < 7; c1++) {
      var tmpList = _timeTable[c1];
      tmpList = tmpList.toSet().toList();
      _uniqueTimeTableEntries.addAll(tmpList);
    }

    _uniqueTimeTableEntries.remove('');
  }

  void updateTaskList() {
    for (var entries in _taskData) {
      entries.setIsImportant(entries.timeTaken >= _inflictionPoint);
    }

    notifyListeners();
  }

  void updateTimeTable(List<List<String>> newTimeTable) {
    _timeTable = newTimeTable;

    Map<String, List<String>> newTimeTableMap = {
      'monday': newTimeTable[0],
      'tuesday': newTimeTable[1],
      'wednesday': newTimeTable[2],
      'thursday': newTimeTable[3],
      'friday': newTimeTable[4],
      'saturday': newTimeTable[5],
      'sunday': newTimeTable[6],
    };

    if (_uniqueTimeTableEntries.isNotEmpty) {
      _uniqueTimeTableEntries.clear();
    }

    List<String> tmpList = [];

    for (int c1 = 0; c1 < 7; c1++) {
      var tmpList2 = _timeTable[c1];
      tmpList2 = tmpList2.toSet().toList();
      tmpList.addAll(tmpList2);
    }
    tmpList = tmpList.toSet().toList();
    tmpList.remove('');
    _uniqueTimeTableEntries.addAll(tmpList);

    print(_uniqueTimeTableEntries);

    _fireStore
        .collection('timeTable')
        .doc(_timeTableDataDocumentID)
        .update({'timeTable': newTimeTableMap});
  }

  void createNewUser(String userEmail) {
    Map<String, List<String>> newTimeTable = {
      'monday': ['', '', '', '', '', '', '', '', ''],
      'tuesday': ['', '', '', '', '', '', '', '', ''],
      'wednesday': ['', '', '', '', '', '', '', '', ''],
      'thursday': ['', '', '', '', '', '', '', '', ''],
      'friday': ['', '', '', '', '', '', '', '', ''],
      'saturday': ['', '', '', '', '', '', '', '', ''],
      'sunday': ['', '', '', '', '', '', '', '', '']
    };

    _timeTableDataDocumentID = _userInflictionDocumentID = userEmail;

    FirebaseAuth.instance.currentUser.updateProfile(
        displayName: userEmail.split('@')[0],
        photoURL:
            'https://robohash.org/${userEmail.split('@')[0]}?size=160x160');

    _fireStore
        .collection('timeTable')
        .doc(_timeTableDataDocumentID)
        .set({'sender': userEmail, 'timeTable': newTimeTable});

    _fireStore.collection('infliction').doc(_userInflictionDocumentID).set({
      'sender': userEmail,
      'inflictionPoint': 172800000,
      'wasDone@timeTaken': []
    });
  }

  //ML Part
  void reCalculateInflictionPoint() async {
    print(_inflictionPoint);

    var data = <Iterable>[
      ['feature1', 'output']
    ];
    for (String s in inflictionData) {
      double time = double.parse(s.split('@')[1]);
      double done = double.parse(s.split('@')[0]);
      data.add([time / 864000000, done]);
    }

    // print(data);

    final dataFrame = DataFrame(data, headerExists: true);
    final targetName = 'output';
    final classifier = LogisticRegressor(
      dataFrame,
      targetName,
      iterationsLimit: 90,
      batchSize: 5,
      positiveLabel: 1.0,
      negativeLabel: 0.0,
      probabilityThreshold: 0.6,
      randomSeed: 76,
      isFittingDataNormalized: true,
    );

    var finalScore = classifier.assess(dataFrame, MetricType.accuracy);
    print(finalScore);

    var x = classifier.interceptScale;
    print(x);
    int newInflictionPoint = 0;
    // String toUpdateEntry;
    var testData = <Iterable>[
      ['feature1']
    ];

    for (double i = 0; i < 864000000; i += 3600000) {
      testData.add([i / 864000000]);
    }

    var predictions = classifier.predict(DataFrame(testData));
    for (var x in predictions.rows) {
      if (x.toString() != '(1.0)')
        newInflictionPoint += 3600000;
      else
        break;
    }
    inflictionData.clear();

    if (newInflictionPoint != _inflictionPoint) {
      _fireStore
          .collection('infliction')
          .doc(_userInflictionDocumentID)
          .update({'inflictionPoint': newInflictionPoint});
    }
  }
}
