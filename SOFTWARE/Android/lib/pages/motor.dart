import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Motor extends StatefulWidget {
  @override
  _MotorState createState() => _MotorState();
}

class _MotorState extends State<Motor> {
  double suhu = 0;
  double flow = 0;
  var warna = Colors.green[300];
  final sumurMax = TextEditingController();
  final sumurMin = TextEditingController();
  final tangkiMax = TextEditingController();
  final tangkiMin = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    dbInit();
    sumurMax.addListener(_setSumurMax);
    sumurMin.addListener(_setSumurMin);
    tangkiMax.addListener(_setTangkiMax);
    tangkiMin.addListener(_setTangkiMin);
  }

  _setSumurMax() {
    print(sumurMax.text);
  }

  _setSumurMin() {
    print(sumurMin.text);
  }

  _setTangkiMax() {
    print(tangkiMax.text);
  }

  _setTangkiMin() {
    print(tangkiMin.text);
  }

  @override
  void dispose() {
    sumurMax.dispose();
    sumurMin.dispose();
    tangkiMax.dispose();
    tangkiMin.dispose();
    super.dispose();
  }

  void dbInit() {
    //baca state mode dari firebase
    dbRef.child("nodeSet").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == "flow" && values != null) {
          setState(() {
            flow = values.toDouble();
          });
        }
        if (key == "suhu" && values != null) {
          setState(() {
            suhu = values.toDouble();
          });
        }
      });
    });
    //listener untuk mode
    dbRef.child("nodeSet").onChildChanged.listen(
      (event) {
        if (event.snapshot.value != null) {
          if (event.snapshot.key == "flow") {
            setState(() {
              flow = event.snapshot.value.toDouble();
            });
          }
          if (event.snapshot.key == "suhu") {
            setState(() {
              suhu = event.snapshot.value.toDouble();
            });

            if (suhu < 60) {
              setState(() {
                warna = Colors.green[300];
              });
            } else if (suhu >= 100) {
              setState(() {
                warna = Colors.red[300];
              });
            } else {
              setState(() {
                warna = Colors.amber;
              });
            }
          }
        }
      },
    );

    dbRef.child("nodeGet").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == "sumur_off_level" && values != null) {
          setState(() {
            sumurMin.text = values.toString();
          });
        }
        if (key == "sumur_on_level" && values != null) {
          setState(() {
            sumurMax.text = values.toString();
          });
        }
      });
    });
    //listener untuk mode
    dbRef.child("nodeGet").onChildChanged.listen(
      (event) {
        if (event.snapshot.key == "sumur_off_level" &&
            event.snapshot.value != null) {
          setState(() {
            sumurMin.text = event.snapshot.value.toString();
          });
        }
        if (event.snapshot.key == "sumur_on_level" &&
            event.snapshot.value != null) {
          setState(() {
            sumurMax.text = event.snapshot.value.toString();
          });
        }
      },
    );
    dbRef.child("tankGet").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == "tangki_min" && values != null) {
          setState(() {
            tangkiMin.text = values.toString();
          });
        }
        if (key == "tangki_max" && values != null) {
          setState(() {
            tangkiMax.text = values.toString();
          });
        }
      });
    });
    //listener untuk mode
    dbRef.child("tankGet").onChildChanged.listen(
      (event) {
        if (event.snapshot.key == "tangki_min" &&
            event.snapshot.value != null) {
          setState(() {
            tangkiMin.text = event.snapshot.value.toString();
          });
        }
        if (event.snapshot.key == "tangki_max" &&
            event.snapshot.value != null) {
          setState(() {
            tangkiMax.text = event.snapshot.value.toString();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("gambar/motor_pump.jpg"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        color: warna,
                        width: 120.0,
                        height: 60.0,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Motor Temp",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${suhu.toStringAsFixed(2)}\u00B0C",
                              style: TextStyle(fontSize: 22.0),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white60,
                        width: 120.0,
                        height: 60.0,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Water Flow",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${flow.toStringAsFixed(2)}mL/s",
                              style: TextStyle(fontSize: 21.0),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: sumurMin,
                              decoration: InputDecoration(
                                  hintText: "00 ~ 13",
                                  labelText: "Sumur alarm",
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Tidak boleh kosong';
                                }
                                if (int.parse(value) > 13) {
                                  return 'Angka Terlalu Besar';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 20.0,
                          ),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: sumurMax,
                              decoration: InputDecoration(
                                  hintText: "00 ~ 13",
                                  labelText: "Sumur reset",
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Tidak boleh kosong';
                                }
                                if (int.parse(value) > 13) {
                                  return 'Angka Terlalu Besar';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: tangkiMin,
                              decoration: InputDecoration(
                                  hintText: "00 ~ 13",
                                  labelText: "Tangki Min",
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Tidak boleh kosong';
                                }
                                if (int.parse(value) > 13) {
                                  return 'Angka Terlalu Besar';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 20.0,
                          ),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: tangkiMax,
                              decoration: InputDecoration(
                                  hintText: "00 ~ 13",
                                  labelText: "Tangki Max",
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Tidak boleh kosong';
                                }
                                if (int.parse(value) > 13) {
                                  return 'Angka Terlalu Besar';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Container(
                        width: 150,
                        height: 60,
                        child: RaisedButton.icon(
                          onPressed: () {
                            print('Button Clicked.');
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Processing Data')));
                              dbRef.child("nodeGet").update({
                                "sumur_off_level": int.parse(sumurMin.text)
                              });
                              dbRef.child("nodeGet").update(
                                  {"sumur_on_level": int.parse(sumurMax.text)});
                              dbRef.child("tankGet").update(
                                  {"tangki_max": int.parse(tangkiMax.text)});
                              dbRef.child("tankGet").update(
                                  {"tangki_min": int.parse(tangkiMin.text)});
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          label: Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          textColor: Colors.white,
                          splashColor: Colors.red,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
