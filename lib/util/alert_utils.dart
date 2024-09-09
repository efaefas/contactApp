import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../constants/app_constants.dart';

class AlertUtils {


  static Future<bool?> showConfirm(BuildContext context,
      {IconData? icon,
        String? message,
        String? confirmText,
        String? denyText,
        Widget? child,
        Color? confirmColor,
        Color? denyColor,
        Color? confirmTextColor,
        Color? denyTextColor}) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 42,
                      height: 42,
                      child: SizedBox(
                        width: 42,
                        height: 42,
                    child:    GestureDetector(
                      onTap: () => Get.back(result: null),
                      child: const Icon(
                        Icons.close,
                        size: 42,
                      ),
                    ),
                      ),
                    ),
                  ),
                  if (icon != null)
                    Column(
                      children: [
                        Icon(
                          icon,
                          color: const Color(0xFF434242),
                          size: AppConstants.h1Size,
                        ),
                        const SizedBox(height: 10.0)
                      ],
                    ),
                  if (message != null) ...[
                    Column(
                      children: [
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: AppConstants.h6Size),
                        ),
                        const SizedBox(height: 10.0)
                      ],
                    ),
                    const SizedBox(height: 5.0),
                  ],
                  if (child != null) ...[
                    child,
                    const SizedBox(height: 5.0),
                  ],
                  ElevatedButton(
                      child: Text(confirmText ?? 'Evet'.tr),
                      onPressed: () => Get.back(result: true)),
                  const SizedBox(height: 5.0),
                  if (denyText != null) ...[
                    ElevatedButton(
                        child: Text(denyText ?? 'Hayır'.tr),
                        onPressed: () => Get.back(result: false)),
                    const SizedBox(height: 10.0),
                  ],
                ],
              ),
            ),
          );
        });
  }

}
