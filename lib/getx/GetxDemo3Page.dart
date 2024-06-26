

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'CounterController.dart';

class GetxDemo3Page extends StatelessWidget {
  final CounterController _counterController = CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX3示例'),
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
              // onPressed: _counterController.increment,
              onPressed: (){
                Get.back();
                // Get.off( "/get1page");
              },
              child: Text('增加'),
            ),
          ],
        ),
      ),
    );
  }
}
