import 'package:Planner/responsive_layout.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  int index = 0;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: ResponsiveLayout.isSmallScreen(context) ? 16 : 0,
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("TEST"),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          for (int i = 0; i < 10; i++) ...[
            DrawerTile(context, Icons.blur_linear, i.toString(), i)
          ]
        ],
      ),
    );
  }

  void _onTapDrawTile(int index) {
    setState(() {
      widget.index = index;
      if (ResponsiveLayout.isSmallScreen(context)) {
        Navigator.pop(context);
      }
    });
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
