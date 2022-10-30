import 'dart:html';

import 'package:flutter/material.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:intl/intl.dart';
import '../color.dart';
import '../widget/scroll.dart';
import '../widget/card.dart';
import '../widget/text.dart';
import '../widget/picker.dart';
import '../firestore.dart';
import '../responsive_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WebsitePage extends StatefulWidget {
  final name = "Website";
  final icon = Icons.web;

  @override
  _WebsitePageState createState() => _WebsitePageState();
}

class _WebsitePageState extends State<WebsitePage> {
  // @override
  // Widget build(BuildContext context) {
  //   return Expanded(
  //     child: SingleChildScrollView(
  //       child: Padding(
  //         padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
  //         child: Website(),
  //       ),
  //     ),
  //   );
  // }

  // Widget Website() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Flexible(
  //         fit: FlexFit.loose,
  //         child: Container(
  //           child: WebView(
  //             initialUrl: "https://google.com",
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: EasyWebView(
        onLoaded: () {},
        src: "https://y8.com",
        // TODO fix
        // can't select any menu in Drawer on Mobile View

        // convertToWidgets: true,
      ),
    );
  }
}
