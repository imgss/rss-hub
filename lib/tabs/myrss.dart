import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
class MyRss extends StatefulWidget {
  @override
  _MyRssState createState() => _MyRssState();
}

class _MyRssState extends State<MyRss>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List rssList;

  @override
  void initState() {
    super.initState();
    _prefs.then((prefs){
      setState(() {
        rssList = prefs.getStringList('rssList') ?? [];
        print(rssList);
      });
    });
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rssList != null) {
      return Scaffold(
      appBar: AppBar(
        title: Text('我的订阅')
      ),
      body: ListView.separated(
        itemBuilder: (context, index){
          return ListTile(
            title: Text(
                rssList[index]
              )
            );
        },
        itemCount: rssList.length,
        separatorBuilder: (context, index){
          return Divider(
            color: Colors.black12,
          );
        },
      )
    );
  } else {
    return Center(
      child: Text('您还没有订阅'),
    );
  }
  }
}