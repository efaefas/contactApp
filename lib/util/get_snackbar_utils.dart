import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetSnackbarUtils {
  static ButtonStyle buttonStyle = TextButton.styleFrom(
    backgroundColor: Colors.white,
  );

  static void notification(title, message, {Function()? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      snackPosition:  SnackPosition.BOTTOM,
      title,
      message,
      colorText: Colors.green.shade800,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 6),
      mainButton: onTap != null
          ? TextButton(
        onPressed: () => onTap(),
        style: buttonStyle,
        child: Text('Show'.tr),
      )
          : null,
      margin: const EdgeInsets.only(bottom: 10.0),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  static void success(title, message, {Function()? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      snackPosition:  SnackPosition.BOTTOM,
      title,
      message,
      colorText: Colors.green.shade800,
      backgroundColor: Colors.white,
      mainButton: onTap != null
          ? TextButton(
        onPressed: () => onTap(),
        style: buttonStyle,
        child: Text('Show'.tr),
      )
          : null,
      margin: const EdgeInsets.only(bottom: 10.0),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  static void error(title, message, {Function? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      snackPosition:  SnackPosition.BOTTOM,
      message,
      colorText: Colors.red.shade800,
      backgroundColor: Colors.white,
      mainButton: onTap != null
          ? TextButton(
        onPressed: () => onTap(),
        style: buttonStyle,
        child: Text('Show'.tr),
      )
          : null,
      margin: const EdgeInsets.only(bottom: 10.0),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  static void warning(title, message, {Function? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition:  SnackPosition.BOTTOM,
      colorText: Colors.orange.shade800,
      backgroundColor: Colors.white,
      mainButton: onTap != null
          ? TextButton(
        onPressed: () => onTap(),
        style: buttonStyle,
        child: Text('Show'.tr),
      )
          : null,
      margin: const EdgeInsets.only(bottom: 10.0),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  static void info(title, message, {Function? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      colorText: Colors.lightBlue.shade800,
      snackPosition:  SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      mainButton: onTap != null
          ? TextButton(
        onPressed: () => onTap(),
        style: buttonStyle,
        child: Text('Show'.tr),
      )
          : null,
      margin: const EdgeInsets.only(bottom: 10.0),
      animationDuration: const Duration(milliseconds: 200),
    );
  }
}
