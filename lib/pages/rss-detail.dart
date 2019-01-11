import "package:flutter/material.dart";
import 'package:dio/dio.dart';
import 'package:webfeed/webfeed.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './webview.dart';
import 'package:flutter/cupertino.dart';
class RssDetail extends StatefulWidget {
  String _url;
  RssDetail(this._url);
  @override
  _RssDetailState createState() => _RssDetailState(_url);
}

class _RssDetailState extends State<RssDetail> {
  String _url;
  RssFeed rssFeed;
  _RssDetailState(this._url);

  @override
  void initState() {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

      _prefs.then((pref){
        var rss = pref.getString(_url);
        print('rss:');
        print(rss);
        if(rss != null){
          Map _rssFeed = json.decode(rss);
          List<MyRssItem> rssItems = [];
          for (var item in _rssFeed['items']){
            rssItems.add(new MyRssItem(
              false,
              item['title'],
              item['pubDate']
            ));
          }

          setState(() {
            rssFeed = RssFeed(
              title: _rssFeed['title'], 
              items: rssItems);
          });
        }
      });

      super.initState();
      Dio dio = new Dio();
      dio.get('https://rsshub.app' + _url).then((res){

        if(res.statusCode == 200){
          print(res.data);
          RssFeed feed = new RssFeed.parse(res.data);
          List<RssItem> items = feed.items;
          List<MyRssItem> _items = [];
          
          for(var item in  items){
            _items.add(MyRssItem(true, item.title, item.pubDate));
          }
          setState((){
            if(rssFeed != null){
              if(rssFeed.items[0].title != _items[0].title){
                rssFeed.items.insertAll(0, _items);
              }
            } else {
              RssFeed _feed = RssFeed(
                title: feed.title,
                items: _items
              );
              rssFeed = _feed;
            }

          });
        }
      });
    }
  
  @override
  void dispose() {
    super.dispose();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((pref){
      Map _rssFeed = {
        "title": rssFeed.title,
        "items": rssFeed.items.map((item){
          return {
            "title": item.title,
            "pubDate": item?.pubDate
          } ;
        }).toList()
      };
      pref.setString(_url, json.encode(_rssFeed));
    });
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
      appBar: AppBar(
        title: Text(rssFeed != null ? rssFeed.title : '加载中'),
      ),
      body: rssFeed != null ? ListView.separated(
        separatorBuilder: (context, index){
          return Divider(color: Colors.black12,);
        },
        itemCount: rssFeed.items.length,
        itemBuilder: (context, index){
          MyRssItem rssItem = rssFeed.items[index];
          return ListTile(
            leading: rssItem.isNew ? Icon(Icons.fiber_new, color: Colors.blueAccent) : null,
            onTap: (){
              print(rssItem.link);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => Web(rssItem.link)),
              );
            },
            title: Text(rssItem.title),
            subtitle: Text(rssItem.pubDate ?? '发布日期未知')
          );
        }
      ) : Center(child: CircularProgressIndicator(),)
    );
  }
}

class MyRssItem extends RssItem {
  bool isNew;
  String title;
  String pubDate;
  MyRssItem(this.isNew, this.title, this.pubDate):super(title: title, pubDate: pubDate);
}