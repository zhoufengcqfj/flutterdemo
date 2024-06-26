
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/CounterModel.dart';
import 'package:flutterdemo/MultiPage.dart';
import 'package:provider/provider.dart';

import 'HomeScreen.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState()  => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ceshi"),
      ),
      body: MultiPage()
      // ChangeNotifierProvider(
      //   create:(context) => CounterModel(),
      //   child: HomeScreen(),
      // ),
      // body:  HomeScreen(),
    );
  }
}