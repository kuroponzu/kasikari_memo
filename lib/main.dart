import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
          title: ("貸し借りメモタイトル"),
          home: new Scaffold(
            appBar: new AppBar(
              title: new Text("貸し借りメモタイトル"),
            ),
            body: new Center(
                child:new Text(
                    "貸し借りメモですよ"
                )
            )
          )
    );
  }
}
