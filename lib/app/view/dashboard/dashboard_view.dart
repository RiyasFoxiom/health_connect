import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/app/controller/dashboard_controller.dart';
import 'package:health_connect/app/view/dashboard/widget/dashboard_card.dart';
import 'package:health_connect/app/view/dashboard/widget/health_chart_widget.dart';
import 'package:health_connect/core/extension/margin_ext.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Obx(
                () => DashboardCard(
                  title: "Steps Today",
                  value: controller.stepValue.value,
                  time: controller.getTimeSinceUpdate(),
                  assetNmae: "activity",
                  borderColor: Color(0xff28BD67),
                ),
              ),
              12.hBox,
              Obx(
                () => DashboardCard(
                  title: "Heart Rate",
                  value: controller.heartValue.value,
                  time: controller.getTimeSinceUpdate(),
                  assetNmae: "heart",
                  borderColor: Color(0xffE64E81),
                ),
              ),
              12.hBox,
              Obx(() {
                final stepsLength = controller.stepsData.length;
                return SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: HealthChart(
                    data: controller.stepsData,
                    title: 'Steps Progress ',
                    lineColor: Color(0xff28BD67),
                    gradientColor: Color(0xff28BD67),
                    unit: 'steps',
                    maxVisiblePoints: 60,
                    showGradient: true,
                  ),
                );
              }),
              12.hBox,
              Obx(() {
                final heartRateLength = controller.heartRateData.length;
                return SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: HealthChart(
                    data: controller.heartRateData,
                    title: 'Heart Rate',
                    lineColor: Color(0xffE64E81),
                    gradientColor: Color(0xffE64E81),
                    unit: 'bpm',
                    maxVisiblePoints: 60,
                    showGradient: true,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
