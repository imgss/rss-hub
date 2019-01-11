import "package:flutter/material.dart";
import 'package:dio/dio.dart';
import '../pages/sub-routes.dart';
import 'package:flutter/cupertino.dart';
class AllRss extends StatefulWidget {

  AllRss();

  @override
  _AllRssState createState() => _AllRssState();
}

class _AllRssState extends State<AllRss>
    with SingleTickerProviderStateMixin {
  Map routes;
  PersistentBottomSheetController ctler;
  @override
  void initState() {
    super.initState();

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
              List subRoutes = routes[routeNames[index]]['routes'];
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => RouteList(subRoutes)),
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