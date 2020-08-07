import 'pages/monitor.dart';
import 'package:flutter/material.dart';
import 'pages/alarm.dart';
import 'pages/motor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_notications_helper.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skripsi',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _notifications = FlutterLocalNotificationsPlugin(); //notifikasi
  final _fireBase = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    _notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    notifikasi();
  }

  void notifikasi() {
    String titelAlarm;
    _fireBase.child("alarm").onChildChanged.listen((event) {
      int _numId;
      String _value;
      if ( event.snapshot.key == "overheat") {
        _numId = 0;
        titelAlarm = "Motor Alarm";
        _value = 'Over heat motor';
      }
      if ( event.snapshot.key == "overload") {
        _numId = 1;
        titelAlarm = "Motor Alarm";
        _value = 'Over current motor';
      }
      if ( event.snapshot.key == "level") {
        _numId = 2;
        titelAlarm = "Level Alarm";
        _value = 'Low watter level';
      }
      if ( event.snapshot.key == "flow") {
        _numId = 3;
        titelAlarm = "Flow Alarm";
        _value = 'Low pressure';
      }
      if (event.snapshot.value == true) {
        showOngoingNotification(FlutterLocalNotificationsPlugin(),
            title: titelAlarm, body: "$_value ", id: _numId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future onSelectNotification(String payload) async {
    _tabController.animateTo(2);
    _notifications.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Kendali Pompa Air"),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(
                Icons.pan_tool,
                color: Colors.purple,
              ),
              text: "Setting",
            ),
            new Tab(
              icon: new Icon(
                Icons.network_check,
                color: Colors.orange[700],
              ),
              text: "Monitor",
            ),
            new Tab(
              icon: new Icon(
                Icons.notifications_active,
                color: Colors.red,
              ),
              text: "Alarm",
            ),
          ],
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Motor(),
          new Monitor(),
          new Alarm(),
        ],
      ),
    );
    // );
  }
}
