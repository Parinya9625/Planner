import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../color.dart';
import '../widget/scroll.dart';
import '../widget/card.dart';
import '../widget/text.dart';
import '../widget/picker.dart';
import '../firestore.dart';
import '../responsive_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final name = "Home";
  final icon = Icons.home;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            TitleBold("Home"),
          ],
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection("classroom")
              .document(DateFormat.EEEE().format(DateTime.now()).toLowerCase())
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
                ...[
                  if (snapshot.data["data"].length != 0) ...[
                    TitleBold("Today Class"),
                    HorizontalScroll(
                      height: 200,
                      children: [
                        for (int index = 0;
                            index < snapshot.data["data"].length;
                            index++) ...[
                          CardCRTime(
                            day: snapshot.data.documentID,
                            data: snapshot.data["data"][index],
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
        StreamBuilder(
          stream: Firestore.instance.collection("event").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            bool showEventTitle = false;
            for (DocumentSnapshot doc in snapshot.data.documents) {
              if (checkEvent(doc.data)) {
                showEventTitle = true;
                break;
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.data.documents.length != 0) ...[
                  if (showEventTitle) ...[
                    TitleBold("Today Event"),
                  ],
                  HorizontalScroll(
                    height: 200,
                    children: [
                      for (DocumentSnapshot doc in snapshot.data.documents) ...[
                        if (checkEvent(doc.data)) ...[
                          CardEVTime(docID: doc.documentID, data: doc.data)
                        ]
                      ]
                    ],
                  ),
                ]
              ],
            );
          },
        ),
        StreamBuilder(
          stream:
              Firestore.instance.collection("work").orderBy("date").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            bool showWorkTitle = false;
            for (DocumentSnapshot doc in snapshot.data.documents) {
              if (checkWork(doc.data["date"])) {
                showWorkTitle = true;
                break;
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.data.documents.length != 0) ...[
                  if (showWorkTitle) ...[
                    TitleBold("Work To-Do"),
                  ],
                  HorizontalScroll(
                    height: 200,
                    children: [
                      for (DocumentSnapshot doc in snapshot.data.documents) ...[
                        if (checkWork(doc.data["date"])) ...[
                          CardWork(
                            docID: doc.documentID,
                            data: doc.data,
                            editable: false,
                          )
                        ]
                      ]
                    ],
                  ),
                ]
              ],
            );
          },
        ),
      ],
    );
  }

  bool checkEvent(Map<String, dynamic> data) {
    DateTime sd = DateTime(
        int.parse(data["sdate"].substring(0, 4)),
        int.parse(data["sdate"].substring(4, 6)),
        int.parse(data["sdate"].substring(6, 8)));
    DateTime ed = DateTime(
        int.parse(data["edate"].substring(0, 4)),
        int.parse(data["edate"].substring(4, 6)),
        int.parse(data["edate"].substring(6, 8)));
    DateTime sdt = DateTime(
        int.parse(data["sdate"].substring(0, 4)),
        int.parse(data["sdate"].substring(4, 6)),
        int.parse(data["sdate"].substring(6, 8)),
        int.parse(data["stime"].split(":")[0]),
        int.parse(data["stime"].split(":")[1]));
    DateTime edt = DateTime(
        int.parse(data["edate"].substring(0, 4)),
        int.parse(data["edate"].substring(4, 6)),
        int.parse(data["edate"].substring(6, 8)),
        int.parse(data["etime"].split(":")[0]),
        int.parse(data["etime"].split(":")[1]));
    DateTime now = DateTime.now();
    // print(sd.toString() + " " + sdt.toString() + " " + edt.toString());
    if (sdt.isBefore(edt)) {
      if (sd == DateTime(now.year, now.month, now.day) ||
          ed == DateTime(now.year, now.month, now.day)) {
        return true;
      }
      if (now.isAfter(sdt) && now.isBefore(edt)) {
        return true;
      }
    }
    return false;
  }

  bool checkWork(String date) {
    DateTime work = DateTime(
        int.parse(date.substring(0, 4)),
        int.parse(date.substring(4, 6)),
        int.parse(date.substring(6, 8)),
        23,
        59);
    DateTime now = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
    return now.isBefore(work) || work == now;
  }
}
