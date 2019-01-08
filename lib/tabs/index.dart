import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "allrss.dart";
import 'myrss.dart';
import "../p_tabview.dart";

class IndexScene extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return new _IndexState();
    }
}

class _IndexState extends State<IndexScene>{
  int _pageIndex = 0;
  final _pages = <Widget>[
    PersistTabview(child: AllRss()),
    PersistTabview(child: MyRss())
  ];

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
        children: List.generate(_pages.length, (int i) {
          return Offstage(
              offstage: i != _pageIndex,
              child: _pages[i]
            );
          }),
        ),
        bottomNavigationBar: CupertinoTabBar(//   底部导航
          currentIndex: _pageIndex,
          onTap: (int i) {
            setState(() {
              _pageIndex = i;
            }); 
            // if (_pages[i] is Scene) {
            //   final _scene = _pages[i] as Scene;
            //   if (_scene.initialized == false) {
            //     _scene.initialized = true;
            //   }
            // }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('全部')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: Text('我的')
            )
          ],
        ),
      );
    }
}