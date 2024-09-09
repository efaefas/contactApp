import 'dart:ui';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:loader_overlay/loader_overlay.dart';

import 'constants/app_constants.dart';
import 'translations/main_translations.dart';
import 'view/master_screen.dart';
import 'view/splash_screen.dart';

void main() async {
  Intl.defaultLocale = "tr";
  timeago.setLocaleMessages('tr', timeago.TrMessages());
  WidgetsFlutterBinding.ensureInitialized();

  await initStorages();

  runApp(const MyApp());
}

Future<void> initStorages() async {
  await GetStorage.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var tm = box.read("themeMode");
    return GlobalLoaderOverlay(child: GetMaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'VTAAT',
      theme: FlexThemeData.light(
        colorScheme: AppConstants.flexSchemeLight,
        //scheme: FlexScheme.blue,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
          inputDecoratorRadius: 15.0,
          inputDecoratorUnfocusedHasBorder: false,
          bottomNavigationBarBackgroundSchemeColor: SchemeColor.primaryContainer,
          textButtonRadius: 10.0,
          elevatedButtonRadius: 10.0,
          outlinedButtonRadius: 10.0,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          elevatedButtonSchemeColor: SchemeColor.primary,
          elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colorScheme: AppConstants.flexSchemeDark,
        //scheme: FlexScheme.blue,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
          inputDecoratorRadius: 15.0,
          inputDecoratorUnfocusedHasBorder: false,
          bottomNavigationBarBackgroundSchemeColor: SchemeColor.primaryContainer,
          textButtonRadius: 10.0,
          elevatedButtonRadius: 10.0,
          outlinedButtonRadius: 10.0,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          elevatedButtonSchemeColor: SchemeColor.primary,
          elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      themeMode: tm != null ? ThemeMode.values.firstWhere((e) => e.toString() == tm,
          orElse: () => ThemeMode.light) : ThemeMode.light,
      initialRoute: ContactsScreen.routePath,
      getPages: [
        GetPage(name: ContactsScreen.routePath, page: () => ContactsScreen()),
      ],
      supportedLocales: AppConstants.supportedLocales.values,
      locale: Locale(box.read('lang') ?? (Get.deviceLocale?.languageCode ?? 'en')),
      fallbackLocale: Locale(Get.deviceLocale?.languageCode ?? 'en'),
      translations: MainTranslations(),
      localeResolutionCallback: (locale, supportedLocales) {
        box.write('lang', locale?.toString() ?? Get.deviceLocale?.languageCode ?? 'en');
        return locale;
      },
    ));
  }
}