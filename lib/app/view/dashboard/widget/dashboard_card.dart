

import 'package:flutter/material.dart';
import 'package:health_connect/app/widget/app_text.dart';
import 'package:health_connect/core/style/colors.dart';
import 'package:health_connect/core/style/fonts.dart';
import 'package:health_connect/shared/widgets/app_svg.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.time,
    required this.borderColor,
    required this.assetNmae,
  });

  final String title, value, time, assetNmae;

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      // height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryBgClr,
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.5),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: borderColor,
            offset: Offset(0, 3),
            spreadRadius: 0,
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                color: Color(0xff737C8C),
                size: 16,
                family: interRegular,
              ),
              AppText(
                value,
                color: Color(0xff21242C),
                size: 28,
                family: poppinsExtraBold,
              ),
              AppText(time, color: Color(0xff757E8F), family: interRegular),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: AppSvg(assetName: assetNmae, color: borderColor),
          ),
        ],
      ),
    );
  }
}
