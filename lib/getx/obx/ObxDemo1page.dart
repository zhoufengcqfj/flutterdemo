

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ObxCounterController.dart';



class ObxDemo1Page extends GetView<ObxCounterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Obx Example')),
      body: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Count: ${controller.count}'), // 直接访问控制器中的状态
              ElevatedButton(
                onPressed: () {
                  controller.increment(); // 调用控制器中的方法来更新状态
                },
                child: Text('Increment'),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ObxCounterController());
  }
}