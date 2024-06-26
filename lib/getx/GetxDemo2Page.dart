

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'CounterController.dart';

class GetxDemo2Page extends StatelessWidget {
  final CounterController _counterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX2示例'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<CounterController>(
              init: _counterController,
              builder: (controller) {
                return Text('计数: ${controller.count}');
              },
            ),
            ElevatedButton(
              onPressed: (){
               _counterController.increment();
              },
              child: Text('增加'),
            ),
            ElevatedButton(
              onPressed: (){
                Get.to('/get3page');
              },
              child: Text('qu3'),
            ),
          ],
        ),
      ),
    );
  }
}
