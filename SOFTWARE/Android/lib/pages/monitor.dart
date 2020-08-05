// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  final nodeMCU = FirebaseDatabase.instance.reference();
  List jsonSample;
  double sumurValue = 0;
  double tankvalue = 0;

  @override
  void initState() {
    super.initState();
    modelListen();
    dbInit();
  }

  void dbInit() {
    nodeMCU.child("nodeSet").once().then(
      (DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, val) {
          if (val != null) {
            if (key == "sumur") {
              setState(() {
                sumurValue = val.toDouble() * 10;
              });
            }
            if (key == "tangki") {
              setState(() {
                tankvalue = val.toDouble() * 10;
              });
            }
          }
        });
      },
    );
    nodeMCU.child("nodeSet").onChildChanged.listen(
      (event) {
        if (event.snapshot.value != null) {
          if (event.snapshot.key == "tangki") {
            setState(() {
              tankvalue = event.snapshot.value.toDouble() * 10;
            });
          }
          if (event.snapshot.key == "sumur") {
            setState(() {
              sumurValue = event.snapshot.value.toDouble() * 10;
            });
          }
        }
      },
    );
  }

  void modelListen() {
    nodeMCU.child("Log").once().then(
      (DataSnapshot snapshot) {
        Map<dynamic, dynamic> map = snapshot.value;
        List<dynamic> list = map.values.toList()
          ..sort((a, b) => b['Jam'].compareTo(a['Jam']));
        setState(() {
          jsonSample = list; //jsonDecode(newString) as List;
        });
      },
    );
  }

  void deleteLog() {
    nodeMCU.child("Log").remove();
  }

  // String getPrettyJSONString(jsonObject) {
  //   JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  //   String jsonString = encoder.convert(json.decode(jsonObject));
  //   return jsonString;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Sumur",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.blueAccent),
                  ),
                  Text(
                    "Tank",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.blueAccent),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.black54, //beground
                      child: SfRadialGauge(
                        key: null,
                        axes: <RadialAxis>[
                          RadialAxis(
                              radiusFactor: 0.98,
                              startAngle: 140,
                              endAngle: 40,
                              minimum: 0,
                              maximum: 130,
                              showAxisLine: false,
                              majorTickStyle: MajorTickStyle(
                                  length: 0.15,
                                  lengthUnit: GaugeSizeUnit.factor,
                                  thickness: 2),
                              labelOffset: 8,
                              axisLabelStyle: GaugeTextStyle(
                                  fontFamily: 'Times',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic),
                              minorTicksPerInterval: 9,
                              interval: 10,
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                    value: sumurValue,
                                    needleStartWidth: 2,
                                    needleEndWidth: 2,
                                    needleColor: const Color(0xFFF67280),
                                    needleLength: 0.8,
                                    lengthUnit: GaugeSizeUnit.factor,
                                    enableAnimation: true,
                                    animationType: AnimationType.bounceOut,
                                    animationDuration: 1500,
                                    knobStyle: KnobStyle(
                                        knobRadius: 8,
                                        sizeUnit: GaugeSizeUnit.logicalPixel,
                                        color: const Color(0xFFF67280)))
                              ],
                              minorTickStyle: MinorTickStyle(
                                  length: 0.08,
                                  thickness: 1,
                                  lengthUnit: GaugeSizeUnit.factor,
                                  color: const Color(0xFFC4C4C4)),
                              axisLineStyle: AxisLineStyle(
                                  color: const Color(0xFFDADADA),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                  thickness: 0.1)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black54, //beground
                      child: SfRadialGauge(
                        key: null,
                        axes: <RadialAxis>[
                          RadialAxis(
                              radiusFactor: 0.98,
                              startAngle: 140,
                              endAngle: 40,
                              minimum: 0,
                              maximum: 130,
                              showAxisLine: false,
                              majorTickStyle: MajorTickStyle(
                                  length: 0.15,
                                  lengthUnit: GaugeSizeUnit.factor,
                                  thickness: 2),
                              labelOffset: 8,
                              axisLabelStyle: GaugeTextStyle(
                                  fontFamily: 'Times',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic),
                              minorTicksPerInterval: 9,
                              interval: 10,
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                    value: tankvalue,
                                    needleStartWidth: 2,
                                    needleEndWidth: 2,
                                    needleColor: const Color(0xFFF67280),
                                    needleLength: 0.8,
                                    lengthUnit: GaugeSizeUnit.factor,
                                    enableAnimation: true,
                                    animationType: AnimationType.bounceOut,
                                    animationDuration: 1500,
                                    knobStyle: KnobStyle(
                                        knobRadius: 8,
                                        sizeUnit: GaugeSizeUnit.logicalPixel,
                                        color: const Color(0xFFF67280)))
                              ],
                              minorTickStyle: MinorTickStyle(
                                  length: 0.08,
                                  thickness: 1,
                                  lengthUnit: GaugeSizeUnit.factor,
                                  color: const Color(0xFFC4C4C4)),
                              axisLineStyle: AxisLineStyle(
                                  color: const Color(0xFFDADADA),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                  thickness: 0.1)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              jsonSample == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : JsonTable(
                      jsonSample,
                      showColumnToggle: true,
                      allowRowHighlight: true,
                      rowHighlightColor: Colors.green.withOpacity(0.7),
                      paginationRowCount: 40,
                      onRowSelect: (index, map) {
                        print(index);
                        print(map);
                      },
                    ),
              SizedBox(
                height: 40.0,
              ),
              Text("Skripsi Kendali Pompa Air Berbasis IoT")
            ],
          ),
        ),
      ),
      floatingActionButton: _getFAB(),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Color(0xFF801E48),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.delete_forever),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              /* do anything */
              deleteLog();
            },
            label: 'Reset Log',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.refresh),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              setState(() {
                jsonSample = null;
                modelListen();
                // _counter = 0;
              });
            },
            label: 'Refres Log',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48))
      ],
    );
  }
}
