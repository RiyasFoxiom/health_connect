import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controller/permission_controller.dart';
import '../../../app/widget/app_text.dart';
import '../../../core/extension/margin_ext.dart';
import '../../../core/style/colors.dart';
import '../../../core/style/fonts.dart';
import '../../../shared/widgets/app_svg.dart';

class PermissionView extends StatelessWidget {
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PermissionController());

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shrinkWrap: true,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.5),
                width: 0.5,
              ),
              borderRadius: BorderRadiusDirectional.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffEDF9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppSvg(
                        assetName: "gard",
                        height: 28,
                        width: 28,
                        color: Color(0xff22C3C3),
                      ),
                    ),
                    8.wBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "Health Connect Permissions",
                            size: 18,
                            family: interBold,
                          ),
                          5.hBox,
                          AppText(
                            "Manage access to your health data. These permissions allow the app to read realtime updates from Health Connect.",
                            family: interRegular,
                            color: Color(0xff757E8F),
                          ),
                          5.hBox,
                          Obx(
                            () => Chip(
                              backgroundColor: controller.allPermissionsGranted
                                  ? colorcyan
                                  : Color(0xffF3F5F7),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                              visualDensity: VisualDensity(vertical: -4),
                              label: Text(
                                controller.allPermissionsGranted
                                    ? "All Granted"
                                    : "Action Required",
                                style: TextStyle(
                                  color: controller.allPermissionsGranted
                                      ? secondaryBgClr
                                      : primaryClr,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => controller.allPermissionsGranted
                      ? SizedBox.shrink()
                      : Container(
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xffFEF7F9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffE23670),
                                offset: Offset(-3, 0),
                                spreadRadius: 0,
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: AppText(
                            "Some permissions are not granted. The app may not function correctly without these permissions.",
                            size: 15,
                            color: primaryClr,
                            family: interRegular,
                          ),
                        ),
                ),
              ],
            ),
          ),
          16.hBox,
          Obx(
            () => PermissionCard(
              icon: Icons.show_chart,
              iconColor: Colors.green[300]!,
              title: 'Steps Record',
              subtitle: 'Read daily step counts and activity data',
              isActive: controller.stepsPermission.value,
              onTap: controller.checkStepsPermission,
            ),
          ),
          16.hBox,
          Obx(
            () => PermissionCard(
              icon: Icons.favorite_border,
              iconColor: Colors.green[300]!,
              title: 'Heart Rate Record',
              subtitle: 'Access heart rate measurements and trends',
              isActive: controller.heartRatePermission.value,
              onTap: controller.checkHeartRatePermission,
            ),
          ),
          
          // if (!controller.allPermissionsGranted) ...[
          //   16.hBox,
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: TextButton(
          //       onPressed: controller.openAppSettings,
          //       child: Text(
          //         'Open Settings',
          //         style: TextStyle(
          //           color: primaryClr,
          //           fontFamily: interBold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}

class PermissionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  const PermissionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          16.wBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    6.wBox,
                    if (isActive)
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ],
                ),
                4.hBox,
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                12.hBox,
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isActive ? 'Revoke' : 'Grant Access',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isActive ? Colors.green[700] : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
