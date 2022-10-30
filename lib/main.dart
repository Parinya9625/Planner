import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Custom
import 'color.dart';
// Page
import 'responsive_layout.dart';
import 'page/home.dart';
import 'page/classrooms.dart';
import 'page/events.dart';
import 'page/works.dart';
import 'page/notes.dart';
import 'page/website.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Planner",
      theme: ThemeData(
        primaryColor: CColor.card,
        textSelectionColor: CColor.background,
        cursorColor: CColor.text,
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        accentColor: Color.fromRGBO(29, 32, 35, 1.0),
        textTheme: TextTheme(
          headline4: TextStyle(color: CColor.text, fontWeight: FontWeight.bold),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Home context
  BuildContext _context;
  int _pageIndex = 0;
  List<Widget> _page = [
    HomePage(),
    ClassroomsPage(),
    EventsPage(),
    WorksPage(),
    NotesPage(),
    WebsitePage(),
  ];
  List<String> _pageName = [
    HomePage().name,
    ClassroomsPage().name,
    EventsPage().name,
    WorksPage().name,
    NotesPage().name,
    WebsitePage().name,
  ];
  List<IconData> _pageIcon = [
    HomePage().icon,
    ClassroomsPage().icon,
    EventsPage().icon,
    WorksPage().icon,
    NotesPage().icon,
    WebsitePage().icon,
  ];

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      // appBar: ResponsiveLayout.isSmallScreen(context)
      //     ? AppBar(
      //         title: Text("APP BAR"),
      //         backgroundColor: CColor().card,
      //       )
      //     : null,
      appBar: AppBar(
        elevation: 8,
        title: Text("Planner"),
        backgroundColor: CColor.card,
        //
        // NEW - TEST ONLY
        actions: [
          if (_pageName[_pageIndex] == "Event") ...[
            PopupMenuButton(
              color: CColor.card,
              icon: Icon(Icons.wrap_text),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 3,
                  child: Text("test"),
                ),
              ],
              onSelected: (value) {
                _onTapDrawTile(value);
              },
            ),
          ],
          IconButton(onPressed: () {}, icon: Icon(Icons.access_alarms))
        ],
      ),
      // END NEW
      //
      drawer: ResponsiveLayout.isSmallScreen(context) ? AppDrawer() : null,
      backgroundColor: CColor.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (ResponsiveLayout.isLargeScreen(context)) ...[AppDrawer()],
          _page[_pageIndex],
        ],
      ),
    );
  }

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
      elevation: 8,
      child: Container(
        // Drawer background color
        color: CColor.card,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text(
                        DateFormat.d().format(DateTime.now()).padLeft(2, "0"),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: CColor.day,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat.EEEE().format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: CColor.day,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMM().format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: CColor.day,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            for (int i = 0; i < _page.length; i++) ...[
              DrawerTile(_context, _pageIcon[i], _pageName[i], i)
            ]
          ],
        ),
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
            Icon(
              icon,
              color: CColor.text,
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(color: CColor.text),
                ),
              ),
            )
          ],
        ),
        onPressed: () {
          _onTapDrawTile(index);
        },
      ),
    );
  }
}
