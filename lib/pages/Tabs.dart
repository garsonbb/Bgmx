import 'package:bgmx/pages/Myself.dart';
import 'package:flutter/material.dart';

import 'Daily.dart';

class ButtonBar extends StatefulWidget {
  ButtonBar({Key key}) : super(key: key);

  _ButtonBarState createState() => _ButtonBarState();
}

class _ButtonBarState extends State<ButtonBar> {
  List pages = [
    DailyListTab(),
    ProgressListTab(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("每日放送"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            title: Text("我的進度"),
          ),
        ],
      ),
    );
  }
}
