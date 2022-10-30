import 'dart:js';

import 'package:flutter/material.dart';
import 'responsive_layout.dart';

// TODO :
// - Clear garbage code
// - Add new feature
// - link to firebase
// - Don't be lazy :D

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TEST",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BuildContext _context;
  int _pageIndex = 0;
  List<Widget> _page = [];
  List<String> _pageName = ["Page 1", "Page 2", "Page 3"];
  List<IconData> _pageIcon = [
    Icons.access_time,
    Icons.add_alarm,
    Icons.airport_shuttle
  ];

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
          ? AppBar(
              title: Text("APP BAR"),
            )
          : null,
      drawer: ResponsiveLayout.isSmallScreen(context) ? AppDrawer() : null,
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Large Screen
          if (!ResponsiveLayout.isSmallScreen(context)) ...[
            // Flexible(
            //   child: Row(
            //     children: [AppDrawer()],
            //   ),
            // )
            AppDrawer()
          ],
          _page[_pageIndex],
          // End Large Screen
        ],
      ),
    );
  }
  // ASDKAS:D

  void _onTapDrawTile(int index) {
    setState(() {
      _pageIndex = index;
      if (ResponsiveLayout.isSmallScreen(_context)) {
        Navigator.pop(_context);
      }
    });
  }

  Widget AppDrawer() {
    return Drawer(
      elevation: ResponsiveLayout.isSmallScreen(_context) ? 16 : 0,
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("TEST"),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          for (int i = 0; i < _page.length; i++) ...[
            DrawerTile(_context, _pageIcon[i], _pageName[i], i)
          ]
        ],
      ),
    );
  }

  Widget DrawerTile(
      BuildContext context, IconData icon, String title, int index) {
    return Container(
      margin: EdgeInsets.all(8),
      child: FlatButton(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon),
            Expanded(
              child: Center(
                child: Text(title),
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          _onTapDrawTile(index);
        },
      ),
    );
  }
}

// class Home extends StatelessWidget {
//   BuildContext _context;
//   int _pageIndex = 0;
//   List<Widget> _page = [Page1(), Page2(), Page3()];

//   @override
//   Widget build(BuildContext context) {
//     _context = context;
//     return Scaffold(
//       appBar: ResponsiveLayout.isSmallScreen(context)
//           ? AppBar(
//               title: Text("APP BAR"),
//             )
//           : null,
//       drawer: ResponsiveLayout.isSmallScreen(context) ? AppDrawer() : null,
//       backgroundColor: Color.fromRGBO(238, 238, 238, 1),
//       body: Column(
//         children: <Widget>[
//           // Large Screen
//           if (!ResponsiveLayout.isSmallScreen(context)) ...[
//             Flexible(
//               child: Row(
//                 children: [AppDrawer(), _page[_pageIndex]],
//               ),
//             )
//           ]
//           // End Large Screen
//         ],
//       ),
//     );
//   }
//   // ASDKAS:D

//   Widget AppDrawer() {
//     return Drawer(
//       elevation: ResponsiveLayout.isSmallScreen(_context) ? 16 : 0,
//       child: ListView(
//         children: [
//           DrawerHeader(
//             child: Text("TEST"),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//           ),
//           for (int i = 0; i < 10; i++) ...[
//             DrawerTile(_context, Icons.blur_linear, i.toString(), i)
//           ]
//         ],
//       ),
//     );
//   }

//   Widget DrawerTile(
//       BuildContext context, IconData icon, String title, int index) {
//     return Container(
//       margin: EdgeInsets.all(8),
//       child: FlatButton(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Icon(icon),
//             Expanded(
//               child: Center(
//                 child: Text(title),
//               ),
//             )
//           ],
//         ),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         onPressed: () {
//           _pageIndex = index;
//         },
//       ),
//     );
//   }
// }
