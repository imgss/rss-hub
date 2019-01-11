import 'package:flutter/material.dart';
import '../common/eventBus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteList extends StatefulWidget {
  @override
  _RouteListState createState() => _RouteListState(_title, _subRoutes);

  List _subRoutes;
  String _title;

  RouteList(this._title, this._subRoutes);

}

class _RouteListState extends State<RouteList> {
  List subRoutes;
  List btnTexts;
  String title;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _RouteListState(this.title, this.subRoutes);

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _prefs.then((prefs){
        List<String> rssList = prefs.getStringList('rssList') ?? [];
        setState(() {
          btnTexts = subRoutes.map((s){
          if(rssList.contains(s)){
              return '已订阅';
            }else{
              return '订阅';
            }
          }).toList();
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title + ' RSS列表')),
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
                        Scaffold.of(context).showSnackBar(SnackBar (
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.blueAccent),
                              Text('订阅成功'),
                            ]
                          ))
                          );
                        eventBus.fire(MyEvent('update:rsslist', data: rssList));
                      },
                      child: Text(btnTexts != null ? btnTexts[index] : '订阅')
                    )
                  ]);
              },
            )
    );
  }
}