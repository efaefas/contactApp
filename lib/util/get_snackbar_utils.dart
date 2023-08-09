import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetSnackbarUtils {
  static ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.white
  );

  static void notification(title, message, {Function()? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message,
        colorText: Colors.white,
        backgroundColor: Colors.green.shade800,
        duration: const Duration(seconds: 6),
        mainButton: onTap != null ? TextButton(onPressed: () => onTap(), style: buttonStyle, child: Text('Show'.tr)) : null,
        animationDuration: const Duration(milliseconds: 200));
  }

  static void success(title, message, {Function()? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message,
        colorText: Colors.white,
        backgroundColor: Colors.green.shade800,
        mainButton: onTap != null ? TextButton(onPressed: () => onTap(), style: buttonStyle, child: Text('Show'.tr)) : null,
        animationDuration: const Duration(milliseconds: 200));
  }

  static void error(title, message, {Function? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade800,
        mainButton: onTap != null ? TextButton(onPressed: () => onTap(), style: buttonStyle, child: Text('Show'.tr))
            : null,
        animationDuration: const Duration(milliseconds: 200));
  }

  static void warning(title, message, {Function? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message,
        colorText: Colors.white,
        backgroundColor: Colors.orange.shade800,
        mainButton: onTap != null ? TextButton(onPressed: () => onTap(), style: buttonStyle, child: Text('Show'.tr)) : null,
        animationDuration: const Duration(milliseconds: 200));
  }

  static void info(title, message, {Function? onTap}) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message,
        colorText: Colors.white,
        backgroundColor: Colors.lightBlue.shade800,
        mainButton: onTap != null ? TextButton(onPressed: () => onTap(), style: buttonStyle, child: Text('Show'.tr)) : null,
        animationDuration: const Duration(milliseconds: 200));
  }
}
