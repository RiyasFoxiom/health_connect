import 'package:flutter/material.dart';
import 'package:health_connect/app/controller/splash_controller.dart';
import 'package:health_connect/app/widget/app_text.dart';
import 'package:health_connect/core/style/fonts.dart';
import 'package:health_connect/shared/widgets/app_lottie.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLottie(assetName: "splashLlogo",height: 150,width: 150,),
            AppText("Health Connect",size: 24,family: interSemiBold,)
          ],
        ),
      ),
    );
  }
}