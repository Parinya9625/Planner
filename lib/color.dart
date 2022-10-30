import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CColor {
  static Color text = Color.fromRGBO(131, 132, 138, 1.0);
  static Color card = Color.fromRGBO(41, 45, 49, 1.0);
  static Color background = Color.fromRGBO(29, 31, 37, 1.0);
  static Color accent = Color.fromRGBO(39, 43, 47, 1.0);

  static Map dayList = {
    "Sun": Color.fromRGBO(255, 69, 58, 1),
    "Mon": Color.fromRGBO(255, 214, 10, 1),
    "Tue": Color.fromRGBO(255, 55, 95, 1),
    "Wed": Color.fromRGBO(48, 209, 88, 1),
    "Thu": Color.fromRGBO(255, 159, 10, 1),
    "Fri": Color.fromRGBO(10, 132, 255, 1),
    "Sat": Color.fromRGBO(191, 90, 242, 1),
  };

  static Color day = dayList[DateFormat.E().format(DateTime.now())];
}

// final _red = Color.fromRGBO(255, 69, 58, 1);
// final _yellow = Color.fromRGBO(255, 214, 10, 1);
// final _pink = Color.fromRGBO(255, 55, 95, 1);
// final _green = Color.fromRGBO(48, 209, 88, 1);
// final _orange = Color.fromRGBO(255, 159, 10, 1);
// final _blue = Color.fromRGBO(10, 132, 255, 1);
// final _purple = Color.fromRGBO(191, 90, 242, 1);
