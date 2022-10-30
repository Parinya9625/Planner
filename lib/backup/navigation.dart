import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.white,
      child: Column(
        children: [
          for (int i = 0; i < 10; i++) ...[
            Container(
              margin: EdgeInsets.all(8),
              child: FlatButton(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.dashboard),
                    Expanded(
                      child: Center(
                        child: Text("Sample " + i.toString()),
                      ),
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onPressed: () {},
              ),
            )
          ]
        ],
      ),
    );
  }
}

// Container(
//               margin: EdgeInsets.all(8),
//               child: FractionallySizedBox(
//                 widthFactor: 1.0,
//                 child: ListTile(
//                   title: Text("Smaple Text"),
//                   leading: Icon(Icons.access_time),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16)),
//                   onTap: () {},
//                   hoverColor: Colors.red,
//                 ),
//               ),
//             )
