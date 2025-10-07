import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/app/controller/landing_controller.dart';
import 'package:health_connect/app/view/dashboard/dashboard_view.dart';
import 'package:health_connect/app/view/landing/widget/bottum_nav_widget.dart';
import 'package:health_connect/app/view/permission/permission_view.dart';
import 'package:health_connect/app/widget/app_text.dart';
import 'package:health_connect/core/style/fonts.dart';
import 'package:health_connect/shared/widgets/app_svg.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key, this.currentIndex = 0});

  final int currentIndex;

  static List<Widget> pages = [DashboardView(), PermissionView()];

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(LandingController(currentIndex: currentIndex));
    return Obx(
      () => Scaffold(
         appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppSvg(
            assetName: "dashboard_actv",
            color: Color.fromRGBO(34, 195, 195, 0.8),
          ),
        ),
        title: AppText("Health Connect", size: 16, family: interSemiBold),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
        body: pages[ctrl.currentIndex.value],
        bottomNavigationBar: AppBottomNav(
          currentIndex: ctrl.currentIndex.value,
          onTap: (index) => ctrl.setIndex(index),
        ),
      ),
    );
  }
}
