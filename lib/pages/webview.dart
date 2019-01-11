import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Web extends StatelessWidget {
  final String url;
  Web(this.url);

  @override
  Widget build (BuildContext context) {
    print(url);
    return Scaffold(
      appBar: AppBar(
        title: Text('帖子详情'),
      ),
      body: url == null 
      ? Center(child: CircularProgressIndicator(backgroundColor: Colors.deepOrange,),)
      : WebView(
        initialUrl: url,
        onWebViewCreated: (controler)async{
          var _url = await controler.currentUrl();
          print(_url);
        },
        javaScriptMode: JavaScriptMode.unrestricted
      )
    );
  }
}