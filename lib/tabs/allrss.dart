import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllRss extends StatefulWidget {
  @override
  _AllRssState createState() => _AllRssState();
}

class _AllRssState extends State<AllRss>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Map routes;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    http.get('https://rsshub.app/api/routes').then((res){
      Map _res = json.decode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          routes = _res['data'];
          print(routes);
        });
      } else {
        print('error');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(routes != null){
      List routeNames = routes.keys.toList();
      return ListView.separated(
        padding: EdgeInsets.all(2.0),
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.black12
          );
        },
        itemCount: routes.length,
        itemBuilder: (BuildContext context, int index) {

          return ListTile(
            onTap: () {
              print(routes[routeNames[index]]);
            },
            title: Text(routeNames[index]),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Text('qwer'),
            ),
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

  }
}