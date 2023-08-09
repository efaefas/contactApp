import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:device_info_plus/device_info_plus.dart';

class Utility {
  static GetStorage box = GetStorage();
  static Widget getAvatar(String? url, String? name, {double fontSize = 20, isCircle = true, fit = BoxFit.cover}) {
    if (url == null && name == null) {
      return Container();
    }
    if (url == null || url.toString().isEmpty) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            Utility.getFirstLetters(name),
            style: TextStyle(color: Colors.white, fontSize: fontSize),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: isCircle ? BorderRadius.circular(100) : BorderRadius.zero,
        child: Container(
          color: Colors.white,
          child: CachedNetworkImage(
            fit: fit,
            imageUrl: url,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            // errorWidget: (context, url, error) => const Icon(Icons.error),
            errorWidget: (context, url, error) => Container(
              padding: const EdgeInsets.all(1),
              child: Image.asset('assets/images/empty.png', fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }

  static Image imageFromBase64String(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return Image.memory(
        base64Decode(
            "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A8U8A408888U488s88c88M8scUsMc488008s88s888cc888s48c0ss8s88ss88c8888880s8888M8o8oMcccsM8M8Es884csE8c8oss8888E848s48088o848Qg8848sU8888co88c8E8s8M4cs8888Qs4488o88E8c8Ms888c8A8s8Msc884sYkY0U88s8sE8c8Ms88888U8884880I4M0M8Isc8s88c888888M8c8gso8QMUMQocw888Mg4g84QcUs8c88888U848wM0cYAAAAAAAAQI88w808w888888E8s8IoY8A4MY88Q88oE80E8c80888s88U88kscg0AoIAs4QI0oU8cU888c888sscEc48AI4UAs88sEAwookMsQ80sAMs8888E8s8s4k4A8oEMgAAgoA88M8c8c8s8888E8s448MQA4QAAAAAUgQ80c8c88888888A8o8s8sgAgAgAAAAAAQ8sE8c8c88wMccEss8IMsUAAAAAAAAAAEs0E8cscUM8888U8s8Yk8E88g8I8Uo88s88Y8Msk8o8w4UE4o8Qgw00wg4QwQggwkQsU0QowUAw888c8s8888s488888cs88s88c8888888AAUkMIQQEgEMIAEIEAIAAAE0EMMogQAM888U8s4os8U88o8M8cs48s80M888M8o8ww0UoY8ww4U04g0wwQowwgw8c004w0g8M8cU88oI88ccss8scMsMMccUU88sc8s8/8QAFBEBAAAAAAAAAAAAAAAAAAAAkP/aAAgBAwEBPxBIP//EABQRAQAAAAAAAAAAAAAAAAAAAJD/2gAIAQIBAT8QSD//xAArEAAABAQGAQMFAQAAAAAAAAAAEDFxAREg8CEwQEFRYVCBkaFgscHh8dH/2gAIAQEAAT8QqR4ojQuJ1bqTqHE43Bwcbg4OJwcHBwcHVOzDjcHUQ8kABGaQoI8KAIoXSEaECPoIwAA7xIdoXaAdS4nUOqcTqXaF2jdS7wjstAR4gAABARQR9IABARqwRmiAjSiM4lXlRlTDsHgEsuRmyow8CABchMPzsDcB/AgaCgyJHQBGhCNQ9DAB/BAggOMewoYY0F3MxBizCRGhhSEaUAvUGAnY5U3B0jGgXwKmCJQOjPlP3EegzDVgUMrESOULBFBGhCAjRg8U3YG7HMh/lngUILohgoYsBwc/MR4cAIUnRPrtsUNhLt5go5aPDBxA++AaYkhG2E9YiA/0BSiSoFvx7ENYoDGNIgB7mMCoTBiCHER9wIgfAnA1BJWjPC5Fw40aMQYP4AQx4FGOmRisp0goKRJaODIiTSZE86tlLCYTDYTB7Cg/wT0AFQkekjkGJllQIAtIklAbCUfissOIiIiIjsBRUgkYlwGAAUhER4A5FSYTCYbDZloCMg/YCJIi2UCcRzRr8kcQcCKEBPNFEmm+woL14J0f2jCBbxEyRA8sgBHkgPcBBOhYuDiMMu4iziRrOIu4ka7iLuIu4iziLuJGu4i7iLOIu4ixiFUxFiFcd+DH3AIJD0JYKIgdoix0GJ8I5OxcaQE//wD/AP8A/wD/APz/AP7B0y+R93hAAAkiCmGxe2EEqdi4qABSKMAPj5TjOBauRvFx3qgjKfExESJJNbDsIGexcUAaiTBYj9wJJEpICzYt1QCAwiqHFVq5G8XXdJGlARlA+AGFiPcIBCUAQ9RHwIZBJYuM0AIAVMP6Agi5YQd1IBauRvF13qgAEZbCDhci4liA/gJEMFi4oA+JMKKR9AolBwLs549keonRKHR0AE84PxVi/wBpwmA+QckPkQLHauSuu6UaUCAjIBBPkSQiAQjihsMQKTsMSIsXFIAnxEbA44H+OOtB/AKghSf1XjblRUkAJCVhgoDHR4oCHrVyVx3QI8EAAYEQShIPcRAFFi4ywS87ZpahFRiZsJMlj7GStXJXXerARlm4ikqPiIncXAWLioEh/NHhI+3HpFItxPRgJn3CibelWSDQdhuJg7MCtXI3i470QSyKMwwCBCwEbOfriNoXLsRA5oRaoGOH+7CI/YHABGGfsIC2VGbDlJYnKNG+j4A1AkVq5K478OHvAEqF7TVclSDYDCH3Oh/ANI6yN9CgSnLhGJWrkbxdd6oRmkMm0OqgXYhowfwYsQ6qaTRvpg8AmBQGRkLVyQuO9UQEZhM6Q6BsnBxYMMaQfoS0GeIQBCEoShKEq3YFigWrkrruhAR4MBJvH5QhpZMTAzMzMzMzMzMz7otTCuO9GkDg4SE4kBBOpHEcZIO0pBCjAioOIm8nh5dA6A8dBPJ5vDzuOycaKDjcZxODshGeBEW8SKCmmu7u7u7u7u7u7u76aUrCkR9PAAABlDKmBlDKjNQMyCAjKEa4AgI0oAI8wAAAAAAAAk+lwDPqcAAAAAAAAGIyHEZH0UyFFAkdiMqchkMhxPKruQ4jIZDifZUSMoMipDLTQdW6g6o7UAdkIzjGvjmcdNY5c4SeVAJAwdgYJCQchJDkIwSF2CQpDMDAwdhSBgkEgQJCYOwSCQSBg7AwSUyEkOQkgkKQMMcaQkZIIpJyyHIU9FxiBIUlIA4klBGlABHigjP/AP/Z"),
        fit: BoxFit.cover,
      );
    }
    if (base64String.contains(',')) {
      base64String = base64String.split(",")[1];
    }
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
    );
  }

  static Image imageFromBase64WidthAndHeight({required String? base64String, required double width, required double height}) {
    if (base64String == null || base64String.isEmpty) {
      return Image.memory(
        base64Decode(
            "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A8U8A408888U488s88c88M8scUsMc488008s88s888cc888s48c0ss8s88ss88c8888880s8888M8o8oMcccsM8M8Es884csE8c8oss8888E848s48088o848Qg8848sU8888co88c8E8s8M4cs8888Qs4488o88E8c8Ms888c8A8s8Msc884sYkY0U88s8sE8c8Ms88888U8884880I4M0M8Isc8s88c888888M8c8gso8QMUMQocw888Mg4g84QcUs8c88888U848wM0cYAAAAAAAAQI88w808w888888E8s8IoY8A4MY88Q88oE80E8c80888s88U88kscg0AoIAs4QI0oU8cU888c888sscEc48AI4UAs88sEAwookMsQ80sAMs8888E8s8s4k4A8oEMgAAgoA88M8c8c8s8888E8s448MQA4QAAAAAUgQ80c8c88888888A8o8s8sgAgAgAAAAAAQ8sE8c8c88wMccEss8IMsUAAAAAAAAAAEs0E8cscUM8888U8s8Yk8E88g8I8Uo88s88Y8Msk8o8w4UE4o8Qgw00wg4QwQggwkQsU0QowUAw888c8s8888s488888cs88s88c8888888AAUkMIQQEgEMIAEIEAIAAAE0EMMogQAM888U8s4os8U88o8M8cs48s80M888M8o8ww0UoY8ww4U04g0wwQowwgw8c004w0g8M8cU88oI88ccss8scMsMMccUU88sc8s8/8QAFBEBAAAAAAAAAAAAAAAAAAAAkP/aAAgBAwEBPxBIP//EABQRAQAAAAAAAAAAAAAAAAAAAJD/2gAIAQIBAT8QSD//xAArEAAABAQGAQMFAQAAAAAAAAAAEDFxAREg8CEwQEFRYVCBkaFgscHh8dH/2gAIAQEAAT8QqR4ojQuJ1bqTqHE43Bwcbg4OJwcHBwcHVOzDjcHUQ8kABGaQoI8KAIoXSEaECPoIwAA7xIdoXaAdS4nUOqcTqXaF2jdS7wjstAR4gAABARQR9IABARqwRmiAjSiM4lXlRlTDsHgEsuRmyow8CABchMPzsDcB/AgaCgyJHQBGhCNQ9DAB/BAggOMewoYY0F3MxBizCRGhhSEaUAvUGAnY5U3B0jGgXwKmCJQOjPlP3EegzDVgUMrESOULBFBGhCAjRg8U3YG7HMh/lngUILohgoYsBwc/MR4cAIUnRPrtsUNhLt5go5aPDBxA++AaYkhG2E9YiA/0BSiSoFvx7ENYoDGNIgB7mMCoTBiCHER9wIgfAnA1BJWjPC5Fw40aMQYP4AQx4FGOmRisp0goKRJaODIiTSZE86tlLCYTDYTB7Cg/wT0AFQkekjkGJllQIAtIklAbCUfissOIiIiIjsBRUgkYlwGAAUhER4A5FSYTCYbDZloCMg/YCJIi2UCcRzRr8kcQcCKEBPNFEmm+woL14J0f2jCBbxEyRA8sgBHkgPcBBOhYuDiMMu4iziRrOIu4ka7iLuIu4iziLuJGu4i7iLOIu4ixiFUxFiFcd+DH3AIJD0JYKIgdoix0GJ8I5OxcaQE//wD/AP8A/wD/APz/AP7B0y+R93hAAAkiCmGxe2EEqdi4qABSKMAPj5TjOBauRvFx3qgjKfExESJJNbDsIGexcUAaiTBYj9wJJEpICzYt1QCAwiqHFVq5G8XXdJGlARlA+AGFiPcIBCUAQ9RHwIZBJYuM0AIAVMP6Agi5YQd1IBauRvF13qgAEZbCDhci4liA/gJEMFi4oA+JMKKR9AolBwLs549keonRKHR0AE84PxVi/wBpwmA+QckPkQLHauSuu6UaUCAjIBBPkSQiAQjihsMQKTsMSIsXFIAnxEbA44H+OOtB/AKghSf1XjblRUkAJCVhgoDHR4oCHrVyVx3QI8EAAYEQShIPcRAFFi4ywS87ZpahFRiZsJMlj7GStXJXXerARlm4ikqPiIncXAWLioEh/NHhI+3HpFItxPRgJn3CibelWSDQdhuJg7MCtXI3i470QSyKMwwCBCwEbOfriNoXLsRA5oRaoGOH+7CI/YHABGGfsIC2VGbDlJYnKNG+j4A1AkVq5K478OHvAEqF7TVclSDYDCH3Oh/ANI6yN9CgSnLhGJWrkbxdd6oRmkMm0OqgXYhowfwYsQ6qaTRvpg8AmBQGRkLVyQuO9UQEZhM6Q6BsnBxYMMaQfoS0GeIQBCEoShKEq3YFigWrkrruhAR4MBJvH5QhpZMTAzMzMzMzMzMz7otTCuO9GkDg4SE4kBBOpHEcZIO0pBCjAioOIm8nh5dA6A8dBPJ5vDzuOycaKDjcZxODshGeBEW8SKCmmu7u7u7u7u7u7u76aUrCkR9PAAABlDKmBlDKjNQMyCAjKEa4AgI0oAI8wAAAAAAAAk+lwDPqcAAAAAAAAGIyHEZH0UyFFAkdiMqchkMhxPKruQ4jIZDifZUSMoMipDLTQdW6g6o7UAdkIzjGvjmcdNY5c4SeVAJAwdgYJCQchJDkIwSF2CQpDMDAwdhSBgkEgQJCYOwSCQSBg7AwSUyEkOQkgkKQMMcaQkZIIpJyyHIU9FxiBIUlIA4klBGlABHigjP/AP/Z"),
        fit: BoxFit.cover,
      );
    }
    if (base64String.contains(',')) {
      base64String = base64String.split(",")[1];
    }
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static bool validateEmail(String? email) {
    return email != null && RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch
      (email);
  }

  static bool validatePhone(String? phone) {
    return phone != null && RegExp(r"^\d{10}$").hasMatch(phone);
  }

  static String? formatPhone(String? phone) {
    return phone?.replaceAll(RegExp(r'[^0-9]'),'');
  }

  static String formatDate(DateTime? date, {String format = 'yyyy-MM-dd', String? onNull}) {
    final DateFormat formatter = DateFormat(format);
    return date != null ? formatter.format(date) : onNull ?? '';
  }

  static getFirstLetters(String? str) {
    if (str == null || str.isEmpty) {
      return '';
    }
    if (str.contains(" ")) {
      var pieces = str.split(" ");
      return pieces[0][0] + pieces[1][0];
    }
    return str[0][0];
  }

  static String getFileNameFromUri(String e) {
    var uri = Uri.parse(e);
    if (uri.pathSegments.isNotEmpty) {
      return uri.pathSegments[uri.pathSegments.length - 1];
    }
    return "";
  }

  static launchExternalUrl(String string) async {
    final uri = Uri.parse(string);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>|\n", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').replaceAll(RegExp(r"\&nbsp;", multiLine: true, caseSensitive: true), ' ');
  }

  static String getInitials(String str) => str.isNotEmpty
      ? str.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  /// Generates a positive random integer uniformly distributed on the range
  /// from [min], inclusive, to [max], inclusive.
  static int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt((max + 1) - min);
  }

  static String bytesToSize(int bytes) {
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    if (bytes == 0) return '0 Byte';
    var i = ((log(bytes) / log(1024)).floor()).toInt();
    return '${(bytes / pow(1024, i)).roundToDouble().toStringAsFixed(2).replaceAll(RegExp(".00\$"), '')} ${sizes[i]}';
  }

  static DateTime startOfWeek(){
    var now = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime endOfWeek(){
    var now = DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime startOfMonth(){
    var now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime endOfMonth(){
    var now = DateTime.now();
    return DateTime(now.month == 12 ? now.year + 1 : now.year, now.month == 12 ? 1 : now.month + 1, 1);
  }

  static String timeAgo(DateTime? date, {bool? short = false}){
    return date != null ? timeago.format(date, locale: '${box.read('lang')}${short == true ? '_short' : ''}'
        '', allowFromNow: true) : '';
  }

  static String getFileSizeString(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static DateTime getLocal(String time) {
    DateTime dateTime = DateTime.parse(time);
    dateTime = dateTime.add(DateTime.parse(time).timeZoneOffset);
    return dateTime.toLocal();
  }

  static double getFileSizeMb(int bytes) {
    return bytes / 1000000.0;
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body?.text).documentElement?.text ?? '';

    return parsedString;
  }

  dynamic convertHtmlToDeltaJson(String? string){
    var desc = json.decode(r'[{"insert":"\n"}]');
    try{
      desc = json.decode(string ?? '');
    } catch (e){
      try{
        var text = Utility().parseHtmlString(string ?? '');
        desc = text.contains('[{"insert"') ? json.decode(text) : json.decode('[{"insert":"$text\\n"}]');
      } catch (e){

        debugPrint(e.toString());
      }
    }
    return desc;
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var deviceData = <String, dynamic>{};
    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
            break;
          case TargetPlatform.iOS:
            deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
            break;
          case TargetPlatform.linux:
            deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
            break;
          case TargetPlatform.macOS:
            deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
            break;
          case TargetPlatform.windows:
            deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
            break;
          case TargetPlatform.fuchsia:
            deviceData = <String, dynamic>{'Error:': 'Fuchsia platform isn\'t supported'};
            break;
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    return deviceData;
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
          (Map<K, List<E>> map, E element) =>
      map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension SafeAccess<T> on Iterable<T> {
  T? safeElementAt(int index) => length <= index ? null : elementAt(index);
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'version': data.version,
    'id': data.id,
    'idLike': data.idLike,
    'versionCodename': data.versionCodename,
    'versionId': data.versionId,
    'prettyName': data.prettyName,
    'buildId': data.buildId,
    'variant': data.variant,
    'variantId': data.variantId,
    'machineId': data.machineId,
  };
}

Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  return <String, dynamic>{
    'browserName': describeEnum(data.browserName),
    'appCodeName': data.appCodeName,
    'appName': data.appName,
    'appVersion': data.appVersion,
    'deviceMemory': data.deviceMemory,
    'language': data.language,
    'languages': data.languages,
    'platform': data.platform,
    'product': data.product,
    'productSub': data.productSub,
    'userAgent': data.userAgent,
    'vendor': data.vendor,
    'vendorSub': data.vendorSub,
    'hardwareConcurrency': data.hardwareConcurrency,
    'maxTouchPoints': data.maxTouchPoints,
  };
}

Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'hostName': data.hostName,
    'arch': data.arch,
    'model': data.model,
    'kernelVersion': data.kernelVersion,
    'osRelease': data.osRelease,
    'activeCPUs': data.activeCPUs,
    'memorySize': data.memorySize,
    'cpuFrequency': data.cpuFrequency,
    'systemGUID': data.systemGUID,
  };
}

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'numberOfCores': data.numberOfCores,
    'computerName': data.computerName,
    'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
  };
}