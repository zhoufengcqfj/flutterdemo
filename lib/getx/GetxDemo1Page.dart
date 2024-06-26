

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/getx/obx/ObxCounterController.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';

import 'CounterController.dart';
import 'GetxDemo2Page.dart';
import 'GetxDemo3Page.dart';
import 'obx/ObxDemo1page.dart';

class GetxDemo1Page extends StatelessWidget {
  // final CounterController _counterController = CounterController();
  final  _counterController = Get.put(CounterController());
  // final  _counterController2 = Get.put(ObxCounterController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: "/get1page", page: ()=>GetxDemo1Page(),

        ),
        GetPage(name: "/get2page", page: ()=>GetxDemo2Page()),
        GetPage(name: "/get3page", page: ()=>GetxDemo3Page()),
        // GetPage(name: "/obxDemo1Page", page: ()=>ObxDemo1Page(),binding: HomeBinding()),
        GetPage(name: "/obxDemo1Page", page: ()=>ObxDemo1Page(),
          // transition: Transition.cupertino,
        ),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text('GetX示例'),
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
                  // Get.toNamed('/get3page');
                  // Get.toNamed('/obxDemo1Page',);
                  Get.to(ObxDemo1Page(),binding: HomeBinding());
                },
                child: Text('增加'),
              ),
              ElevatedButton(
                onPressed: (){
                  Get.toNamed('/get2page');
                },
                child: Text('去2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
