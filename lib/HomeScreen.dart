import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CounterModel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Example'),
      ),
      body: Column(
        children: [
          Center(
            child: Consumer<CounterModel>(builder: (context,counter,child)=> Text('${counter.count}')),
          )
        ],
      ),
      // Center(
      //   // 使用Consumer来监听CounterModel
      //   child: Consumer<CounterModel>(
      //     builder: (context, counter, child) => Text('${counter.count}'),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 不需要监听改变时，可以直接使用Provider.of来访问模型
          // Provider.of<CounterModel>(context, listen: false).increment();
          Provider.of<CounterModel>(context,listen: false).increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}