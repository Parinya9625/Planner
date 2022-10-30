import 'dart:html';

import 'package:flutter/material.dart';
import '../color.dart';
import '../widget/scroll.dart';
import '../widget/card.dart';
import '../widget/text.dart';
import '../widget/picker.dart';
import '../firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassroomsPage extends StatefulWidget {
  final name = "Classrooms";
  final icon = Icons.schedule;

  @override
  _ClassroomsPageState createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
          child: classroom(),
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

  Widget classroom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TitleBold("Classrooms"),
            Spacer(),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: CColor.text,
              ),
              label: Text("Add Class"),
              textColor: CColor.text,
              onPressed: () => _add(context),
            ),
          ],
        ),

        // WORK !
        StreamBuilder(
          stream: Firestore.instance
              .collection("classroom")
              .orderBy("day")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Padding(
                padding: EdgeInsets.only(top: 7),
                child: LinearProgressIndicator(
                  backgroundColor: CColor.accent,
                  minHeight: 2,
                ),
              );
            if (snapshot.hasError) return Text("Error");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(),
                for (DocumentSnapshot doc in snapshot.data.documents) ...[
                  if (doc["data"].length != 0) ...[
                    TitleBold(Capitalize(doc.documentID) + " Class"),
                    HorizontalScroll(
                      height: 200,
                      children: [
                        // for (LinkedHashMap data in doc["data"]) ...[
                        //   CardClassroom(
                        //     day: doc.documentID,
                        //     data: data,
                        //     document: doc,
                        //   )
                        // ],
                        for (int index = 0;
                            index < doc["data"].length;
                            index++) ...[
                          CardClassroom(
                            index: index,
                            day: doc.documentID,
                            data: doc["data"][index],
                          )
                        ],
                      ],
                    ),
                  ],
                ]
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _add(BuildContext context) {
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

    // Fix _day > dropdawnmenu : don't update day if set controller.text
    // Fix TimePicker : same issue

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CColor.card,
          title: TitleBold("Add Class"),
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
                            hour: 23,
                            minute: 59,
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
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop();
                  fs_AddClass(_day.text, _subject.text, _stime.text,
                      _etime.text, _room.text, _section.text, _no.text);
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
