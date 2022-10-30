import 'package:Planner/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../color.dart';

class CustomTimePicker extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final int hour;
  final int minute;

  const CustomTimePicker(
      {Key key, this.controller, this.icon, this.hour = 0, this.minute = 0})
      : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TimeOfDay _oldTime;
  TimeOfDay _selectTime;

  @override
  void initState() {
    // // Fix time
    if (widget.controller.text.length == 0) {
      _selectTime = TimeOfDay(hour: widget.hour, minute: widget.minute);
      widget.controller.text = widget.hour.toString().padLeft(2, "0") +
          ":" +
          widget.minute.toString().padLeft(2, "0");
    } else {
      List hs = widget.controller.text.split(":");
      _selectTime = TimeOfDay(hour: int.parse(hs[0]), minute: int.parse(hs[1]));
    }
    _oldTime = _selectTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                widget.icon,
                size: 24,
                color: CColor.text,
              ),
            ),
          ],
          Expanded(
            child: FlatButton(
              child: Text(
                widget.controller.text,
                style: TextStyle(fontSize: 17),
              ),
              textColor: CColor.text,
              onPressed: () async {
                _selectTime = await _CTimePicker(context, _selectTime);
                setState(() {
                  if (_selectTime != null) {
                    _oldTime = _selectTime;
                    widget.controller.text =
                        _selectTime.hour.toString().padLeft(2, "0") +
                            ":" +
                            _selectTime.minute.toString().padLeft(2, "0");
                  } else {
                    _selectTime = _oldTime;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay> _CTimePicker(BuildContext context, TimeOfDay currentTime) {
    // final now = DateTime.now();
    return showTimePicker(
      context: context,
      // initialTime: TimeOfDay.now(),
      initialTime: currentTime,
      // initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget child) {
        // return MediaQuery(
        //   data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        //   child: child,
        // );
        return Theme(
          data: ThemeData.dark().copyWith(
            textSelectionColor: CColor.background,
            cursorColor: CColor.text,
            textSelectionHandleColor: CColor.text,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            colorScheme: ColorScheme.dark(
              primary: CColor.text,
              surface: CColor.card,
              onSurface: CColor.text,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          ),

          // END
        );
      },
    );
  }
}

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String date;

  const CustomDatePicker({Key key, this.controller, this.icon, this.date})
      : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _oldDate;
  DateTime _selectDate;
  TextEditingController _textDate = TextEditingController();

  @override
  void initState() {
    _selectDate = DateTime.now();
    widget.controller.text = _selectDate.year.toString() +
        _selectDate.month.toString().padLeft(2, "0") +
        _selectDate.day.toString().padLeft(2, "0");
    if (widget.date != null) {
      _selectDate = DateTime(
          int.parse(widget.date.substring(0, 4)),
          int.parse(widget.date.substring(4, 6)),
          int.parse(widget.date.substring(6, 8)));
      widget.controller.text = widget.date;
    }
    _textDate.text = _selectDate.day.toString() +
        " " +
        DateFormat.MMMM().format(_selectDate) +
        " " +
        _selectDate.year.toString();
    _oldDate = _selectDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                widget.icon,
                size: 24,
                color: CColor.text,
              ),
            ),
          ],
          Expanded(
            child: FlatButton(
              child: Text(
                _textDate.text,
                style: TextStyle(fontSize: 17),
              ),
              textColor: CColor.text,
              onPressed: () async {
                _selectDate = await _CDatePicker(context, _selectDate);
                setState(() {
                  if (_selectDate != null) {
                    _oldDate = _selectDate;
                    _textDate.text = _selectDate.day.toString() +
                        " " +
                        DateFormat.MMMM().format(_selectDate) +
                        " " +
                        _selectDate.year.toString();
                    widget.controller.text = _selectDate.year.toString() +
                        _selectDate.month.toString().padLeft(2, "0") +
                        _selectDate.day.toString().padLeft(2, "0");
                  } else {
                    _selectDate = _oldDate;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime> _CDatePicker(BuildContext context, DateTime currentTime) {
    return showDatePicker(
      context: context,
      initialDate: currentTime,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            accentColor: CColor.text,
            dialogBackgroundColor: CColor.card,
            textSelectionColor: CColor.background,
            cursorColor: CColor.text,
            textSelectionHandleColor: CColor.text,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            colorScheme: ColorScheme.dark(
              primary: CColor.text,
              surface: CColor.card,
              onSurface: CColor.text,
            ),
          ),
          child: child,
        );
      },
    );
  }
}

class CustomColorPicker extends StatefulWidget {
  final TextEditingController controller;
  final String color;

  const CustomColorPicker({Key key, this.controller, this.color})
      : super(key: key);

  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  int _color;
  List color = [
    0XFFF44336,
    0XFFE91E63,
    0XFF9C27B0,
    0XFF673AB7,
    0XFF3F51B5,
    0XFF2196F3,
    0XFF03A9F4,
    0XFF00BCD4,
    0XFF009688,
    0XFF4CAF50,
    0XFF8BC34A,
    0XFFCDDC39,
    0XFFFFEB3B,
    0XFFFFC107,
    0XFFFF9800,
    0XFFFF5722,
    0XFF795548,
    0XFF9E9E9E,
    0XFF607D8B,
  ];

  @override
  void initState() {
    if (widget.color == null || color.indexOf(int.parse(widget.color)) == -1) {
      _color = color[0];
    } else {
      _color = int.parse(widget.color);
    }
    widget.controller.text = _color.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      child: FlatButton(
        color: Color(_color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: null,
        onPressed: () => _colorPick(context),
      ),
    );
  }

  Widget _colorPick(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CColor.card,
            content: Container(
              width: 255,
              child: Wrap(
                children: color.map<Widget>((c) {
                  return Container(
                    width: 35,
                    height: 35,
                    margin: EdgeInsets.all(8),
                    child: FlatButton(
                      color: Color(c),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: null,
                      onPressed: () {
                        setState(() {
                          _color = c;
                          widget.controller.text = _color.toString();
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  );
                }).toList(),

                // [

                //   // for (int i = 0; i < 10; i++) ...[
                //   //   Container(
                //   //     width: 35,
                //   //     height: 35,
                //   //     margin: EdgeInsets.all(8),
                //   //     child: FlatButton(
                //   //       color: Color(0xFF20a6b0),
                //   //       shape: RoundedRectangleBorder(
                //   //           borderRadius: BorderRadius.circular(20)),
                //   //       onPressed: () {},
                //   //     ),
                //   //   ),
                //   // ]
                // ],
              ),
            ),
          );
        });
  }
}
