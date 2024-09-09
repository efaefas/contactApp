import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const double h1Size = 40;
  static const double h2Size = 36;
  static const double h3Size = 32;
  static const double h4Size = 28;
  static const double h5Size = 24;
  static const double h6Size = 20;
  static const double h7Size = 16;
  static const double h8Size = 12;
  static const double h9Size = 10;

  static const supportedLocales = {'Türkçe': Locale('tr'), 'English': Locale('en')};

  static const bool useLocal = true;
  static const String baseUrlDev = useLocal ? "http://146.59.52.68:11235/" : "";


  static String getWebserviceUrl() {
      return '${baseUrlDev}api/';
  }

  static ColorScheme flexSchemeLight = ColorScheme.fromSeed(
    seedColor: const Color(0xff7098cd),
    brightness: Brightness.light,

    primary: const Color(0xff7098cd),
    secondary: const Color(0xff0f1515),
    tertiary: const Color(0xff907463),
    error: const Color(0xffb82d40),
    background: const Color(0xffd4e1df),
  );

  static ColorScheme flexSchemeDark = ColorScheme.fromSeed(
    seedColor: const Color(0xff7098cd),
    brightness: Brightness.dark,

    primary: const Color(0xff7098cd),
    secondary: const Color(0xff0f1515),
    tertiary: const Color(0xff907463),
    error: const Color(0xffb82d40),
    background: const Color(0xffd4e1df),
  );

  static Color pageColor = const Color(0xfff4f4f4);
}