import "package:flutter/material.dart";

class MyRss extends StatefulWidget {
  @override
  _MyRssState createState() => _MyRssState();
}

class _MyRssState extends State<MyRss>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}