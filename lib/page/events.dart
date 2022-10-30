import 'dart:html';

import 'package:flutter/material.dart';
import '../color.dart';
import '../widget/card.dart';
import '../widget/text.dart';
import '../widget/picker.dart';
import '../firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsPage extends StatefulWidget {
  final name = "Event";
  final icon = Icons.event;

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
          child: home(),
        ),
      ),
    );
  }

  Widget _line() {
    return Divider(
      thickness: 2,
      color: CColor.accent,
      height: 16,
    );
  }

  Widget home() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TitleBold("Events"),
            Spacer(),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: CColor.text,
              ),
              label: Text("Add Event"),
              textColor: CColor.text,
              onPressed: () => _add(context),
            ),
          ],
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection("event")
              .orderBy("sdate")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.only(top: 7),
                child: LinearProgressIndicator(
                  backgroundColor: CColor.accent,
                  minHeight: 2,
                ),
              );
            }
            return FractionallySizedBox(
              widthFactor: 1,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  _line(),
                  for (DocumentSnapshot doc in snapshot.data.documents) ...[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 16, bottom: 0, left: 8, right: 8),
                      child: CardEvent(docID: doc.documentID, data: doc.data),
                    )
                  ]
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _add(BuildContext context) {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CColor.card,
          title: TitleBold("Add Event"),
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
                          ),
                        ),
                      ],
                    ),
                    CustomDatePicker(
                      controller: _sdate,
                      icon: Icons.calendar_today,
                    ),
                    CustomDatePicker(
                      controller: _edate,
                      icon: Icons.arrow_forward,
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
                            hour: 23,
                            minute: 59,
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
                  fs_AddEvent(_title.text, _color.text, _sdate.text,
                      _edate.text, _stime.text, _etime.text, _location.text);
                }
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
