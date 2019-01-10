import "package:flutter/material.dart";
import 'package:dio/dio.dart';
import 'package:webfeed/webfeed.dart';
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
      // TODO: implement initState
      super.initState();
      Dio dio = new Dio();
      dio.get('https://rsshub.app' + _url).then((res){
        print(res);
        if(res.statusCode == 200){
          print(res.data);
          setState((){
            rssFeed = new RssFeed.parse(res.data);
          });
          print(rssFeed.title);
        }
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
          var rssItem = rssFeed.items[index];
          return ListTile(
            onTap: (){
              print(rssItem.link);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => Web(rssItem.link)),
              );
            },
            title: Text(rssItem.title),
          );
        }
      ) : Center(child: CircularProgressIndicator(),)
    );
  }
}