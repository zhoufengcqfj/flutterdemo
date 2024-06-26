import 'package:get/get.dart';

class ObxCounterController extends GetxController {
  var count = 0.obs;

  void increment() {
    count++;
    update();
  }
}

