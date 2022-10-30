import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget smallScreen;
  final Widget largeScreen;

  const ResponsiveLayout(
      {Key key, @required this.largeScreen, this.smallScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 769;
  }

  // static bool isMediumScreen(BuildContext context) {
  //   return MediaQuery.of(context).size.width > 768 &&
  //       MediaQuery.of(context).size.width < 1024;
  // }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 768;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isLargeScreen(context)) {
          return largeScreen;
        } else if (isSmallScreen(context)) {
          return smallScreen ?? largeScreen;
        }
        // else if (isMediumScreen(context)) {
        //   return mediumScreen;
        // }
      },
    );
  }
}
