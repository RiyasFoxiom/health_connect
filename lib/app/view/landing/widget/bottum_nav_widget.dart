import 'package:flutter/material.dart';
import 'package:health_connect/core/extension/string_ext.dart';
import 'package:health_connect/core/style/colors.dart';
import 'package:health_connect/core/style/fonts.dart';
import 'package:health_connect/shared/widgets/app_svg.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final menus = ["dashboard", 'permission'];
    return BottomNavigationBar(
      selectedFontSize: 12,
      onTap: (index) => onTap(index),
      currentIndex: currentIndex,
      elevation: 10,
      items: menus
          .map(
            (menu) => BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: BnvIcon(iconName: menu, color: primaryTextClr),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: BnvIcon(iconName: "${menu}_actv", color: colorcyan),
              ),
              label: menu.upperFirst,
            ),
          )
          .toList(),
      showUnselectedLabels: true,
      backgroundColor: secondaryBgClr,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
          color: colorcyan, fontSize: 12, fontFamily: interRegular),
      unselectedLabelStyle: TextStyle(
          color: primaryTextClr, fontSize: 12, fontFamily: interRegular),
      fixedColor: primaryClr,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
    );
  }
}

class BnvIcon extends StatelessWidget {
  const BnvIcon({
    super.key,
    required this.iconName,
    required this.color,
  });

  final String iconName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: AppSvg(assetName: iconName, color: color),
    );
  }
}