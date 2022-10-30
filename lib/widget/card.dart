import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:Planner/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../color.dart';
import 'picker.dart';
import 'text.dart';
import 'dart:async';

Widget MyCard(String text) {
  return Card(
    color: CColor.card,
    child: Container(
      width: 350,
      height: 200,
      child: ListTile(
        title: Text(text),
        subtitle: Text("Subtitle"),
        onTap: () {},
      ),
    ),
  );
}

Map<String, dynamic> findDifTime(String st, String et, Timer timer) {
  String difTime;
  String status;
  double progress;

  Map<String, Color> color = {
    "yellow": CColor.dayList["Mon"],
    "green": CColor.dayList["Wed"],
    "red": CColor.dayList["Sun"]
  };

  if (et == "00:00") {
    difTime = "End";
    status = "red";
    progress = 1.0;
    timer.cancel();
    return {
      "status": status,
      "time": difTime,
      "color": color[status],
      "progress": progress
    };
  }

  List shs = st.split(":");
  List ehs = et.split(":");
  DateTime now = DateTime.now();
  DateTime stime = DateTime(
      now.year, now.month, now.day, int.parse(shs[0]), int.parse(shs[1]));
  DateTime etime = DateTime(
      now.year, now.month, now.day, int.parse(ehs[0]), int.parse(ehs[1]));

  int now_sec = (now.hour * 60 * 60) + (now.minute * 60) + now.second;
  int stime_sec = (stime.hour * 60 * 60) + (stime.minute * 60) + stime.second;
  int etime_sec = (etime.hour * 60 * 60) + (etime.minute * 60) + etime.second;

  // Find dif 00:00 - stime [ yellow ]
  progress = 1.0 - ((stime_sec - now_sec) / stime_sec);
  if (stime.difference(now).inHours > 0) {
    difTime = "in " + stime.difference(now).inHours.toString() + " Hours";
    status = "yellow";
  } else if (stime.difference(now).inMinutes > 0) {
    difTime = "in " + stime.difference(now).inMinutes.toString() + " Minutes";
    status = "yellow";
  } else if (stime.difference(now).inSeconds > 0) {
    difTime = "in " + stime.difference(now).inSeconds.toString() + " Seconds";
    status = "yellow";
  } else {
    // Find dif stime - etime [ green ]
    progress = 1.0 - ((now_sec - stime_sec) / (etime_sec - stime_sec));
    if (etime.difference(now).inHours > 0) {
      difTime = etime.difference(now).inHours.toString() + " Hours left";
      status = "green";
    } else if (etime.difference(now).inMinutes > 0) {
      difTime = etime.difference(now).inMinutes.toString() + " Minutes left";
      status = "green";
    } else if (etime.difference(now).inSeconds > 0) {
      difTime = etime.difference(now).inSeconds.toString() + " Seconds left";
      status = "green";
    } else {
      difTime = "End";
      status = "red";
      progress = 1.0;
      timer.cancel();
    }
  }

  return {
    "status": status,
    "time": difTime,
    "color": color[status],
    "progress": progress
  };
}

class CardClassroom extends StatelessWidget {
  final String day;
  final int index;
  final LinkedHashMap data;

  const CardClassroom({Key key, this.index, this.day, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CColor.card,
      child: Container(
        width: 350,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(data["subject"],
                      style: TextStyle(
                        color: CColor.dayList[Capitalize(day.substring(0, 3))],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("Time : " + data["stime"] + " - " + data["etime"],
                      style: TextStyle(
                        color: CColor.text,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("Room : " + data["room"],
                      style: TextStyle(
                        color: CColor.text,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("Section : " + data["section"],
                      style: TextStyle(
                        color: CColor.text,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("No : " + data["no"],
                      style: TextStyle(
                        color: CColor.text,
                      )),
                ),
              ],
            ),
          ),
          onLongPress: () {
            _edit(context);
          },
        ),
      ),
    );
  }

  Widget _edit(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // controller
    final _day = TextEditingController();
    final _subject = TextEditingController();
    final _stime = TextEditingController();
    final _etime = TextEditingController();
    final _room = TextEditingController();
    final _section = TextEditingController();
    final _no = TextEditingController();
    // end controller
    _day.text = Capitalize(day);
    _subject.text = data["subject"];
    _stime.text = data["stime"];
    _etime.text = data["etime"];
    _room.text = data["room"];
    _section.text = data["section"];
    _no.text = data["no"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CColor.card,
          title: TitleBold("Edit Class"),
          titlePadding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
            child: Form(
              key: _formKey,
              child: Container(
                width: 500,
                child: Column(
                  children: [
                    DropdownMenu(
                      controller: _day,
                      icon: Icons.calendar_today,
                      item: [
                        "Sunday",
                        "Monday",
                        "Tuesday",
                        "Wednesday",
                        "Thursday",
                        "Friday",
                        "Saturday"
                      ],
                    ),
                    InputField(
                        icon: Icons.subject,
                        hint: "Subject",
                        controller: _subject,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter a subject";
                          }
                        }),
                    Row(
                      children: [
                        Flexible(
                          child: CustomTimePicker(
                            icon: Icons.access_time,
                            controller: _stime,
                            hour: 0,
                            minute: 0,
                          ),
                        ),
                        Flexible(
                          child: CustomTimePicker(
                            icon: Icons.arrow_forward,
                            controller: _etime,
                            hour: 24,
                            minute: 0,
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      icon: Icons.business,
                      hint: "Room",
                      controller: _room,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter a room";
                        }
                      },
                    ),
                    InputField(
                      icon: Icons.group,
                      hint: "Section",
                      controller: _section,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter a section";
                        }
                      },
                    ),
                    InputField(
                      icon: Icons.face,
                      hint: "No",
                      controller: _no,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter a number";
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Submit"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop();
                  fs_UpdateClass(
                      day,
                      _day.text,
                      index,
                      _subject.text,
                      _stime.text,
                      _etime.text,
                      _room.text,
                      _section.text,
                      _no.text);
                }
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Delete"),
              onPressed: () {
                final editContext = Navigator.of(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: CColor.card,
                        title: Text(
                          "Delete Class",
                          style: TextStyle(color: CColor.text),
                        ),
                        content: Text(
                          "Are you sure you want to delete this class?",
                          style: TextStyle(color: CColor.text),
                        ),
                        actions: [
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Delete"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              fs_RemoveClass(day, index);
                              editContext.pop();
                            },
                          ),
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          actionsPadding: EdgeInsets.only(
            right: 16,
            bottom: 8,
          ),
        );
      },
    );
  }
}

class CardCRTime extends StatefulWidget {
  final String day;
  final LinkedHashMap data;

  const CardCRTime({Key key, this.day, this.data}) : super(key: key);

  @override
  _CardCRTimeState createState() => _CardCRTimeState();
}

class _CardCRTimeState extends State<CardCRTime> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CColor.card,
      child: Container(
        width: 350,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(widget.data["subject"],
                      style: TextStyle(
                        color: CColor
                            .dayList[Capitalize(widget.day.substring(0, 3))],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                      "Time : " +
                          widget.data["stime"] +
                          " - " +
                          widget.data["etime"],
                      style: TextStyle(
                        color: CColor.text,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("Room : " + widget.data["room"],
                      style: TextStyle(
                        color: CColor.text,
                      )),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        findDifTime(widget.data["stime"], widget.data["etime"],
                            _timer)["time"],
                        style: TextStyle(
                          color: CColor.text,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: findDifTime(widget.data["stime"],
                        widget.data["etime"], _timer)["progress"],
                    backgroundColor: CColor.background,
                    valueColor: AlwaysStoppedAnimation<Color>(findDifTime(
                        widget.data["stime"],
                        widget.data["etime"],
                        _timer)["color"]),
                  ),
                ),
              ],
            ),
          ),
          onLongPress: () {},
        ),
      ),
    );
  }
}

class CardEvent extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docID;

  const CardEvent({Key key, this.docID, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime sMonth = DateTime(DateTime.now().year,
        int.parse(data["sdate"].substring(4, 6)), DateTime.now().day);
    DateTime eMonth = DateTime(DateTime.now().year,
        int.parse(data["edate"].substring(4, 6)), DateTime.now().day);

    return Card(
      color: CColor.card,
      child: Container(
        width: 350,
        height: 200,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        data["title"].toUpperCase(),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(int.parse(data["color"])),
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data["sdate"].substring(6, 8),
                      style: TextStyle(
                        color: CColor.text,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Text(
                        DateFormat.MMMM().format(sMonth),
                        style: TextStyle(
                          color: CColor.text,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        data["sdate"].substring(0, 4),
                        style: TextStyle(
                          color: CColor.text,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "To : " +
                        data["edate"].substring(6, 8) +
                        " " +
                        DateFormat.MMMM().format(eMonth) +
                        " " +
                        data["edate"].substring(0, 4),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CColor.text,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Time : " + data["stime"] + " - " + data["etime"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CColor.text,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  "At : " + data["location"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CColor.text,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          onLongPress: () {
            _edit(context);
          },
        ),
      ),
    );
  }

  Widget _edit(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // controller
    final _title = TextEditingController();
    final _color = TextEditingController();
    final _sdate = TextEditingController();
    final _edate = TextEditingController();
    final _stime = TextEditingController();
    final _etime = TextEditingController();
    final _location = TextEditingController();
    // end controller
    _title.text = data["title"];
    _color.text = data["color"];
    _sdate.text = data["sdate"];
    _edate.text = data["edate"];
    _stime.text = data["stime"];
    _etime.text = data["etime"];
    _location.text = data["location"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CColor.card,
          title: TitleBold("Edit Event"),
          titlePadding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
            child: Form(
              key: _formKey,
              child: Container(
                width: 500,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InputField(
                            icon: Icons.subject,
                            hint: "Title",
                            controller: _title,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter a subject";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: CustomColorPicker(
                            controller: _color,
                            color: _color.text,
                          ),
                        ),
                      ],
                    ),
                    CustomDatePicker(
                      controller: _sdate,
                      icon: Icons.calendar_today,
                      date: _sdate.text,
                    ),
                    CustomDatePicker(
                      controller: _edate,
                      icon: Icons.arrow_forward,
                      date: _edate.text,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: CustomTimePicker(
                            icon: Icons.access_time,
                            controller: _stime,
                            hour: 0,
                            minute: 0,
                          ),
                        ),
                        Flexible(
                          child: CustomTimePicker(
                            icon: Icons.arrow_forward,
                            controller: _etime,
                            hour: 24,
                            minute: 0,
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      icon: Icons.location_on,
                      hint: "Location",
                      controller: _location,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter a location";
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Submit"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop();
                  fs_UpdateEvent(docID, _title.text, _color.text, _sdate.text,
                      _edate.text, _stime.text, _etime.text, _location.text);
                }
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Delete"),
              onPressed: () {
                final editContext = Navigator.of(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: CColor.card,
                        title: Text(
                          "Delete Class",
                          style: TextStyle(color: CColor.text),
                        ),
                        content: Text(
                          "Are you sure you want to delete this event?",
                          style: TextStyle(color: CColor.text),
                        ),
                        actions: [
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Delete"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              fs_RemoveEvent(docID);
                              editContext.pop();
                            },
                          ),
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          actionsPadding: EdgeInsets.only(
            right: 16,
            bottom: 8,
          ),
        );
      },
    );
  }
}

class CardEVTime extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docID;

  const CardEVTime({Key key, this.docID, this.data}) : super(key: key);

  @override
  _CardEVTimeState createState() => _CardEVTimeState();
}

class _CardEVTimeState extends State<CardEVTime> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(DateTime.now().year,
        int.parse(widget.data["sdate"].substring(4, 6)), DateTime.now().day);

    return Card(
      color: CColor.card,
      child: Container(
        width: 350,
        height: 200,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    widget.data["title"].toUpperCase(),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(int.parse(widget.data["color"])),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Time : " +
                        widget.data["stime"] +
                        " - " +
                        widget.data["etime"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CColor.text,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  "At : " + widget.data["location"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CColor.text,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        findDifTime(widget.data["stime"], widget.data["etime"],
                            _timer)["time"],
                        style: TextStyle(
                          color: CColor.text,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: findDifTime(widget.data["stime"],
                        widget.data["etime"], _timer)["progress"],
                    backgroundColor: CColor.background,
                    valueColor: AlwaysStoppedAnimation<Color>(findDifTime(
                        widget.data["stime"],
                        widget.data["etime"],
                        _timer)["color"]),
                  ),
                ),
              ],
            ),
          ),
          onLongPress: () {},
        ),
      ),
    );
  }
}

class CardWork extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docID;
  final bool editable;

  const CardWork({Key key, this.docID, this.data, this.editable = true})
      : super(key: key);

  bool _EndWork(String date) {
    DateTime work = DateTime(
        int.parse(date.substring(0, 4)),
        int.parse(date.substring(4, 6)),
        int.parse(date.substring(6, 8)),
        23,
        59);
    DateTime now = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
    return now.isAfter(work);
  }

  @override
  Widget build(BuildContext context) {
    DateTime month = DateTime(DateTime.now().year,
        int.parse(data["date"].substring(4, 6)), DateTime.now().day);

    return Card(
      color: CColor.card,
      child: Container(
        width: 350,
        height: 200,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data["title"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(int.parse(data["color"])),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      data["description"],
                      style: TextStyle(
                        color: CColor.text,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Text(
                  "End : " +
                      data["date"].substring(6, 8) +
                      " " +
                      DateFormat.MMMM().format(month) +
                      " " +
                      data["date"].substring(0, 4),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _EndWork(data["date"])
                        ? CColor.dayList["Sun"]
                        : CColor.text,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          onLongPress: () {
            if (editable) {
              _edit(context);
            }
          },
        ),
      ),
    );
  }

  Widget _edit(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // controller
    final _title = TextEditingController();
    final _color = TextEditingController();
    final _desc = TextEditingController();
    final _date = TextEditingController();
    // end controller

    _title.text = data["title"];
    _color.text = data["color"];
    _desc.text = data["description"];
    _date.text = data["date"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CColor.card,
          title: TitleBold("Edit Work"),
          titlePadding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
            child: Form(
              key: _formKey,
              child: Container(
                width: 500,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InputField(
                            icon: Icons.subject,
                            hint: "Title",
                            controller: _title,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter a title";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: CustomColorPicker(
                            controller: _color,
                            color: data["color"],
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      icon: Icons.comment,
                      hint: "Description",
                      controller: _desc,
                      multiline: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter a description";
                        }
                      },
                    ),
                    CustomDatePicker(
                      controller: _date,
                      icon: Icons.calendar_today,
                      date: data["date"],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Submit"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop();
                  fs_UpdateWork(
                      docID, _title.text, _color.text, _desc.text, _date.text);
                }
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Delete"),
              onPressed: () {
                final editContext = Navigator.of(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: CColor.card,
                        title: Text(
                          "Delete Class",
                          style: TextStyle(color: CColor.text),
                        ),
                        content: Text(
                          "Are you sure you want to delete this work?",
                          style: TextStyle(color: CColor.text),
                        ),
                        actions: [
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Delete"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              fs_RemoveWork(docID);
                              editContext.pop();
                            },
                          ),
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          actionsPadding: EdgeInsets.only(
            right: 16,
            bottom: 8,
          ),
        );
      },
    );
  }
}

class CardNote extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docID;

  const CardNote({Key key, this.docID, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CColor.card,
      child: Container(
        width: 350,
        height: 200,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data["title"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(int.parse(data["color"])),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      data["description"],
                      style: TextStyle(
                        color: CColor.text,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onLongPress: () {
            _edit(context);
          },
        ),
      ),
    );
  }

  Widget _edit(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // controller
    final _title = TextEditingController();
    final _color = TextEditingController();
    final _desc = TextEditingController();
    // end controller

    _title.text = data["title"];
    _color.text = data["color"];
    _desc.text = data["description"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CColor.card,
          title: TitleBold("Edit Note"),
          titlePadding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
            child: Form(
              key: _formKey,
              child: Container(
                width: 500,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InputField(
                            icon: Icons.subject,
                            hint: "Title",
                            controller: _title,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter a title";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: CustomColorPicker(
                            controller: _color,
                            color: data["color"],
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      icon: Icons.comment,
                      hint: "Description",
                      controller: _desc,
                      multiline: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter a description";
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Submit"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop();
                  fs_UpdateNote(docID, _title.text, _color.text, _desc.text);
                }
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Delete"),
              onPressed: () {
                final editContext = Navigator.of(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: CColor.card,
                        title: Text(
                          "Delete Class",
                          style: TextStyle(color: CColor.text),
                        ),
                        content: Text(
                          "Are you sure you want to delete this note?",
                          style: TextStyle(color: CColor.text),
                        ),
                        actions: [
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Delete"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              fs_RemoveNote(docID);
                              editContext.pop();
                            },
                          ),
                          FlatButton(
                            textColor: CColor.text,
                            splashColor: Color.fromRGBO(29, 32, 35, 1.0),
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            FlatButton(
              textColor: CColor.text,
              splashColor: Color.fromRGBO(29, 32, 35, 1.0),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          actionsPadding: EdgeInsets.only(
            right: 16,
            bottom: 8,
          ),
        );
      },
    );
  }
}
