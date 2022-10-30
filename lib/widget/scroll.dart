import 'package:flutter/material.dart';
import '../color.dart';

Widget HorizontalScroll({double height, List<Widget> children = const []}) {
  return Container(
    height: height,
    child: ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: children,
    ),
  );
}
