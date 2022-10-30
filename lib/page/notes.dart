import 'dart:html';

import 'package:flutter/material.dart';
import '../color.dart';
import '../widget/card.dart';
import '../widget/text.dart';
import '../widget/picker.dart';
import '../firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  final name = "Notes";
  final icon = Icons.note;

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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
            TitleBold("Notes"),
            Spacer(),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: CColor.text,
              ),
              label: Text("Add Note"),
              textColor: CColor.text,
              onPressed: () => _add(context),
            ),
          ],
        ),
        StreamBuilder(
          stream: Firestore.instance.collection("note").snapshots(),
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
                      child: CardNote(docID: doc.documentID, data: doc.data),
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
    final _desc = TextEditingController();
    // end controller

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CColor.card,
          title: TitleBold("Add Note"),
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
                  fs_AddNote(_title.text, _color.text, _desc.text);
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
