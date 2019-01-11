import 'package:flutter/material.dart';
import '../common/eventBus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteList extends StatefulWidget {
  @override
  _RouteListState createState() => _RouteListState(_subRoutes);

  List _subRoutes;

  RouteList(this._subRoutes);

}

class _RouteListState extends State<RouteList> {
  List subRoutes;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _RouteListState(this.subRoutes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('rss列表')),
      body: ListView.separated(
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
                        // 不可重复添加
                        if(rssList.contains(subRoutes[index])){
                          Scaffold.of(context).showSnackBar(SnackBar (content: Text('无需重复订阅'),));
                          return false;
                        }
                        rssList.add(subRoutes[index]);
                        await prefs.setStringList('rssList', rssList);
                        Scaffold.of(context).showSnackBar(SnackBar (content: Text('订阅成功'),));
                        eventBus.fire(MyEvent('update:rsslist', data: rssList));
                      },
                      child: Text('订阅')
                    )
                  ]);
              },
            )
    );
  }
}