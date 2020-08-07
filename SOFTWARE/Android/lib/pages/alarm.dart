import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final dbAlarm = FirebaseDatabase.instance.reference();
  List<bool> status = [false, false, false, false];
  final List<String> normal = [
    'Normal current motor',
    'Normal temperature',
    'Normal water level',
    'Normal pressure'
  ];
  final List<String> alarm = [
    'Over current motor',
    'Over heat motor',
    'Low watter level',
    'Low pressure'
  ];

  final List<String> normalMsg = [
    'Arus motor dalam keadaan normal',
    'Suhu motor dalam keadaan normal',
    'Level air sumur normal',
    'Tekanan air normal'
  ];
  final List<String> alarmMsg = [
    'Arus motor berlebih, cehek motor lalu tekan reset',
    'Suhu motor berlebih, cehek motor lalu tekan reset',
    'Level air sumur normal, cehek level lalu tekan reset',
    'Tekanan air tidak normal, cehek motor dan level lalu tekan reset'
  ];

  int nilai;
  @override
  void initState() {
    super.initState();
    dbInit();
  }

  void dbInit() {
    //baca state mode dari firebase
    dbAlarm.child("alarm").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == "flow" && values != null) {
          setState(() {
            status[3] = values.toString() == "true" ? true : false;
          });
        }
        if (key == "level" && values != null) {
          setState(() {
            status[2] = values.toString() == "true" ? true : false;
          });
        }
        if (key == "overheat" && values != null) {
          setState(() {
            status[1] = values.toString() == "true" ? true : false;
          });
        }
        if (key == "overload" && values != null) {
          setState(() {
            status[0] = values.toString() == "true" ? true : false;
          });
        }
      });
    });
    //listener untuk mode
    // child("alarm").onChildChanged.listen((event)
    dbAlarm.child("alarm").onChildChanged.listen(
      (event) {
        print(event.snapshot.key.toString() +
            " " +
            event.snapshot.value.toString());
        if (event.snapshot.key == "flow" && event.snapshot.value != null) {
          setState(() {
            status[3] =
                event.snapshot.value.toString() == "true" ? true : false;
          });
        }
        if (event.snapshot.key == "level" && event.snapshot.value != null) {
          setState(() {
            status[2] =
                event.snapshot.value.toString() == "true" ? true : false;
          });
        }
        if (event.snapshot.key == "overheat" && event.snapshot.value != null) {
          setState(() {
            status[1] =
                event.snapshot.value.toString() == "true" ? true : false;
          });
        }
        if (event.snapshot.key == "overload" && event.snapshot.value != null) {
          setState(() {
            status[0] =
                event.snapshot.value.toString() == "true" ? true : false;
          });
        }
      },
    );
  }

  List<Widget> createItems() {
    List<Widget> items = List<Widget>();
    for (var i = 0; i < 4; i++) {
      if (status[i] == true) {
        items.add(
          Card(
            color: Colors.yellow[100],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    size: 50.0,
                    color: Colors.red,
                  ),
                  title: Text(this.alarm[i]),
                  subtitle: Text(this.alarmMsg[i]),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Reset'),
                      onPressed: () {
                        if (i == 3) {
                          dbAlarm
                              .child("nodeGet")
                              .update({"flow_reset": false});
                        }
                        print(i);
                        // widget._preseter.dbSetInt('V$i', 0);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        items.add(
          Card(
            color: Colors.blue[100],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.check_box,
                    size: 50.0,
                    color: Colors.green,
                  ),
                  title: Text(this.normal[i]),
                  subtitle: Text(this.normalMsg[i]),
                ),
              ],
            ),
          ),
        );
      }
      items.add(Container(height: 10.0));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15.0),
      children: createItems(),
    );
  }
}
