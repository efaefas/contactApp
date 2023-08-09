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

  static const bool useLocal = false;
  static const String baseUrlDev = useLocal ? "http://192.168.1.102:44331/" : "https://veridevi.kodfu.com/";
  static const String baseUrlLive = "https://veridevi.kodfu.com/";

  static String getWebserviceUrl() {
    if(kDebugMode){
      return '${baseUrlDev}api/';
    }
    else {
      return '${baseUrlLive}api/';
    }
  }

  static String getHubUrl() {
    if(kDebugMode){
      return '${baseUrlDev}hubs/';
    }
    else {
      return '${baseUrlLive}hubs/';
    }
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
}