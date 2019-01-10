import "package:flutter/material.dart";
import 'package:dio/dio.dart';
import 'dart:convert';
import '../common/eventBus.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AllRss extends StatefulWidget {

  AllRss();

  @override
  _AllRssState createState() => _AllRssState();
}

class _AllRssState extends State<AllRss>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map routes;
  PersistentBottomSheetController ctler;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    eventBus.on<MyEvent>().listen((data){
      print(data.text);
      print(ctler);
      if(data.text == 'closeSheet' && ctler != null){
        ctler.close();
      }

    });
    Dio dio = new Dio();
    print('initState');
    dio.get('https://rsshub.app/api/routes').then((res){
      print(res.data is Map);

      if (res.statusCode == 200) {
        setState(() {
          routes = res.data['data'];
          print(routes);
        });
      } else {
        print('error');
      }
    }).catchError((){
      print('error');
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
              List subRoutes = routes[routeNames[index]]['routes'];
              ctler = showBottomSheet(
                context: context,
                builder: (context){
                  return ListView.separated(
                    padding: EdgeInsets.only(top: 20.0),
                    itemCount: subRoutes.length,
                    separatorBuilder: (context, index){
                      return Divider(
                        color: Colors.black12,
                      );
                    },
                    itemBuilder: (context, index){
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              subRoutes[index],
                              textAlign: TextAlign.center,
                            ),
                          ),

                          FlatButton(
                            textColor: Colors.blueAccent,
                            onPressed: () async {
                              final SharedPreferences prefs = await _prefs;
                              List<String> rssList = prefs.getStringList('rssList') ?? [];
                              rssList.add(subRoutes[index]);
                              print(rssList.length);
                              await prefs.setStringList('rssList', rssList);
                              eventBus.fire(MyEvent('update:rsslist', data: rssList));
                            },
                            child: Text('订阅')
                          )
                        ]);
                    },
                  );
                }
              );
            },
            title: Text(routeNames[index]),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Text('有${routes[routeNames[index]]['routes'].length}个RSS订阅'),
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