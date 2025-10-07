import 'package:get/get.dart';

class LandingController extends GetxController {
  RxInt currentIndex = 0.obs;

  LandingController({int currentIndex = 0}) {
    this.currentIndex.value = currentIndex;
  }
 

  setIndex(int index) {
    currentIndex(index);
  }
}
