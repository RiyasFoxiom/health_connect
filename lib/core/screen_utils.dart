import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Screen {
  static Future? open(Widget page) => Get.to(page);

  static Future? openClosingCurrent(Widget page) => Get.off(page);

  static Future? openAsNewPage(Widget page) => Get.offAll(() => page);

  static close({Object? result}) => Get.back(result: result);

  static closeDialog({Object? result}) => Get.back(result: result);
}