import "package:flutter/material.dart";
import 'package:dio/dio.dart';
import 'package:webfeed/webfeed.dart';

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

    if(rssFeed != null){
      return Scaffold(
      appBar: AppBar(
        title: Text(rssFeed.title),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index){
          return Divider(color: Colors.black12,);
        },
        itemCount: rssFeed.items.length,
        itemBuilder: (context, index){
          var rssItem = rssFeed.items[index];
          return ListTile(
            title: Text(rssItem.title),
          );
        }
      )
    );
    } else {
      return Center(child: Text('loading'),);
    }
  }
}