import 'package:get/get.dart';
import 'package:health_connect/app/view/landing/landing_view.dart';
import 'package:health_connect/core/screen_utils.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 2), () {
      Screen.open(LandingView());
    });
    super.onInit();
  }
}
